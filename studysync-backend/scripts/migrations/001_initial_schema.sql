-- ============================================================================
-- StudySync Database Schema - PostgreSQL 16
-- Version: 1.0.0
-- ============================================================================

-- Enable required extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "postgis";     -- For geolocation
CREATE EXTENSION IF NOT EXISTS "pg_trgm";     -- For text search optimization
CREATE EXTENSION IF NOT EXISTS "btree_gin";   -- For composite indexes

-- ============================================================================
-- 1. INSTITUTIONS
-- ============================================================================

CREATE TABLE institutions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    
    -- Basic Information
    name VARCHAR(255) NOT NULL,
    name_fr VARCHAR(255),
    name_en VARCHAR(255),
    short_name VARCHAR(50),
    acronym VARCHAR(20),
    
    -- Location
    city VARCHAR(100) NOT NULL,
    region VARCHAR(100),
    country VARCHAR(3) DEFAULT 'CMR',
    address TEXT,
    coordinates GEOGRAPHY(POINT, 4326), -- PostGIS point
    
    -- Type & System
    type VARCHAR(50) NOT NULL, -- public_university, private_university, grande_ecole
    academic_system VARCHAR(20) NOT NULL, -- francophone, anglophone, both
    
    -- Contact
    website TEXT,
    email VARCHAR(255),
    phone VARCHAR(20),
    
    -- Status
    active BOOLEAN DEFAULT TRUE,
    verified BOOLEAN DEFAULT FALSE,
    
    -- Metadata
    metadata JSONB DEFAULT '{}',
    
    -- Timestamps
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Constraints
    CONSTRAINT valid_type CHECK (type IN ('public_university', 'private_university', 'grande_ecole', 'institute', 'college')),
    CONSTRAINT valid_system CHECK (academic_system IN ('francophone', 'anglophone', 'both'))
);

-- Indexes
CREATE INDEX idx_institutions_city ON institutions(city);
CREATE INDEX idx_institutions_type ON institutions(type);
CREATE INDEX idx_institutions_active ON institutions(active);
CREATE INDEX idx_institutions_coordinates ON institutions USING GIST(coordinates);
CREATE INDEX idx_institutions_search ON institutions USING GIN(
    to_tsvector('simple', 
        COALESCE(name, '') || ' ' || 
        COALESCE(name_fr, '') || ' ' || 
        COALESCE(name_en, '') || ' ' || 
        COALESCE(acronym, '')
    )
);

COMMENT ON TABLE institutions IS 'Universities and educational institutions in Cameroon';

-- ============================================================================
-- 2. USERS
-- ============================================================================

CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    
    -- Authentication
    phone VARCHAR(20) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    
    -- Basic Profile
    name VARCHAR(255) NOT NULL,
    profile_photo_url TEXT,
    bio TEXT,
    date_of_birth DATE,
    gender VARCHAR(20),
    
    -- Academic Information
    institution_id UUID REFERENCES institutions(id) ON DELETE SET NULL,
    faculty VARCHAR(100),
    department VARCHAR(100),
    level VARCHAR(50), -- Licence 1, Licence 2, Master 1, etc.
    academic_system VARCHAR(20), -- francophone, anglophone
    student_id VARCHAR(100), -- University student ID
    graduation_year INTEGER,
    
    -- Location
    city VARCHAR(100),
    campus_location JSONB, -- {name: "Ngoa-Ekelle", lat: 3.8667, lng: 11.5167}
    
    -- Preferences
    language_preference VARCHAR(5) DEFAULT 'fr', -- fr, en, both
    study_preferences JSONB DEFAULT '{}',
    -- Structure: {
    --   time_preference: "evening",
    --   study_style: "discussion",
    --   preferred_locations: ["library", "campus"],
    --   session_length: "2hr",
    --   group_size: "small",
    --   internet_access: "wifi",
    --   willing_to_travel: "city"
    -- }
    
    -- Availability (weekly schedule)
    availability JSONB DEFAULT '{}',
    -- Structure: {
    --   monday: ["14:00-18:00", "19:00-21:00"],
    --   tuesday: ["16:00-20:00"],
    --   ...
    -- }
    
    -- Notification Preferences
    notification_preferences JSONB DEFAULT '{}',
    -- Structure: {
    --   channel: "whatsapp", // sms, whatsapp, email, push
    --   session_reminders: true,
    --   new_messages: true,
    --   group_updates: true,
    --   marketing: false,
    --   digest_frequency: "weekly"
    -- }
    
    -- Verification Status
    verified BOOLEAN DEFAULT FALSE,
    phone_verified_at TIMESTAMP,
    email_verified_at TIMESTAMP,
    student_id_verified BOOLEAN DEFAULT FALSE,
    student_id_verified_at TIMESTAMP,
    
    -- Premium
    premium BOOLEAN DEFAULT FALSE,
    premium_plan VARCHAR(20), -- monthly, yearly
    premium_started_at TIMESTAMP,
    premium_expires_at TIMESTAMP,
    
    -- Security
    two_factor_enabled BOOLEAN DEFAULT FALSE,
    two_factor_secret VARCHAR(255),
    
    -- Privacy
    profile_visibility VARCHAR(20) DEFAULT 'public', -- public, institution, private
    show_last_name BOOLEAN DEFAULT TRUE,
    allow_messages BOOLEAN DEFAULT TRUE,
    
    -- Status
    active BOOLEAN DEFAULT TRUE,
    banned BOOLEAN DEFAULT FALSE,
    ban_reason TEXT,
    banned_at TIMESTAMP,
    
    -- Activity
    last_login_at TIMESTAMP,
    last_active_at TIMESTAMP,
    
    -- Metadata
    metadata JSONB DEFAULT '{}',
    
    -- Timestamps
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP, -- Soft delete
    
    -- Constraints
    CONSTRAINT valid_language CHECK (language_preference IN ('fr', 'en', 'both')),
    CONSTRAINT valid_academic_system CHECK (academic_system IN ('francophone', 'anglophone', 'both')),
    CONSTRAINT valid_visibility CHECK (profile_visibility IN ('public', 'institution', 'private')),
    CONSTRAINT valid_premium_plan CHECK (premium_plan IN ('monthly', 'yearly') OR premium_plan IS NULL),
    CONSTRAINT valid_phone CHECK (phone ~ '^\+[0-9]{10,15}$')
);

-- Indexes
CREATE UNIQUE INDEX idx_users_phone ON users(phone) WHERE deleted_at IS NULL;
CREATE UNIQUE INDEX idx_users_email ON users(email) WHERE email IS NOT NULL AND deleted_at IS NULL;
CREATE INDEX idx_users_institution ON users(institution_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_users_city ON users(city) WHERE deleted_at IS NULL;
CREATE INDEX idx_users_premium ON users(premium) WHERE deleted_at IS NULL;
CREATE INDEX idx_users_verified ON users(verified) WHERE deleted_at IS NULL;
CREATE INDEX idx_users_active ON users(active) WHERE deleted_at IS NULL;
CREATE INDEX idx_users_created ON users(created_at DESC);
CREATE INDEX idx_users_campus_location ON users USING GIN(campus_location);
CREATE INDEX idx_users_availability ON users USING GIN(availability);
CREATE INDEX idx_users_name_search ON users USING GIN(to_tsvector('simple', name));

COMMENT ON TABLE users IS 'Student user accounts';
COMMENT ON COLUMN users.study_preferences IS 'JSONB object containing study preferences';
COMMENT ON COLUMN users.availability IS 'JSONB object with weekly availability schedule';

-- ============================================================================
-- 3. COURSES
-- ============================================================================

CREATE TABLE courses (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    
    -- Association
    institution_id UUID REFERENCES institutions(id) ON DELETE CASCADE,
    
    -- Basic Information
    code VARCHAR(50) NOT NULL, -- e.g., "MAT 201"
    name VARCHAR(255) NOT NULL,
    name_fr VARCHAR(255),
    name_en VARCHAR(255),
    description TEXT,
    
    -- Organization
    faculty VARCHAR(100),
    department VARCHAR(100),
    level VARCHAR(50), -- Licence 1, Licence 2, etc.
    
    -- Details
    language VARCHAR(5), -- fr, en, both
    credits INTEGER,
    hours_per_week DECIMAL(4,2),
    semester VARCHAR(20), -- S1, S2, S3, etc.
    
    -- Status
    active BOOLEAN DEFAULT TRUE,
    
    -- Metadata
    metadata JSONB DEFAULT '{}',
    
    -- Timestamps
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Constraints
    UNIQUE(institution_id, code),
    CONSTRAINT valid_language CHECK (language IN ('fr', 'en', 'both'))
);

-- Indexes
CREATE INDEX idx_courses_institution ON courses(institution_id);
CREATE INDEX idx_courses_code ON courses(code);
CREATE INDEX idx_courses_faculty ON courses(faculty);
CREATE INDEX idx_courses_department ON courses(department);
CREATE INDEX idx_courses_level ON courses(level);
CREATE INDEX idx_courses_active ON courses(active);
CREATE INDEX idx_courses_search ON courses USING GIN(
    to_tsvector('simple', 
        COALESCE(code, '') || ' ' || 
        COALESCE(name, '') || ' ' || 
        COALESCE(name_fr, '') || ' ' || 
        COALESCE(name_en, '')
    )
);

COMMENT ON TABLE courses IS 'Academic courses offered by institutions';

-- ============================================================================
-- 4. USER_COURSES (Many-to-Many)
-- ============================================================================

CREATE TABLE user_courses (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    
    -- Relationships
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    course_id UUID NOT NULL REFERENCES courses(id) ON DELETE CASCADE,
    
    -- Details
    skill_level VARCHAR(20) NOT NULL DEFAULT 'average', -- struggling, average, strong
    enrolled_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Status
    active BOOLEAN DEFAULT TRUE,
    completed BOOLEAN DEFAULT FALSE,
    completed_at TIMESTAMP,
    grade VARCHAR(10),
    
    -- Timestamps
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Constraints
    UNIQUE(user_id, course_id),
    CONSTRAINT valid_skill_level CHECK (skill_level IN ('struggling', 'average', 'strong'))
);

-- Indexes
CREATE INDEX idx_user_courses_user ON user_courses(user_id) WHERE active = TRUE;
CREATE INDEX idx_user_courses_course ON user_courses(course_id) WHERE active = TRUE;
CREATE INDEX idx_user_courses_skill ON user_courses(skill_level);
CREATE INDEX idx_user_courses_active ON user_courses(active);

COMMENT ON TABLE user_courses IS 'Courses that users are currently taking or have taken';

-- ============================================================================
-- 5. STUDY_GROUPS
-- ============================================================================

CREATE TABLE study_groups (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    
    -- Ownership
    host_user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    course_id UUID REFERENCES courses(id) ON DELETE SET NULL,
    
    -- Basic Information
    title VARCHAR(255) NOT NULL,
    description TEXT,
    language VARCHAR(5) NOT NULL, -- fr, en, both
    
    -- Difficulty & Type
    difficulty_level VARCHAR(20) NOT NULL, -- beginner, intermediate, advanced, mixed
    study_type VARCHAR(50), -- exam_prep, homework, project, general
    tags TEXT[], -- Array of tags
    
    -- Schedule
    date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME, -- Calculated from duration
    duration_minutes INTEGER NOT NULL,
    timezone VARCHAR(50) DEFAULT 'Africa/Douala',
    
    -- Recurrence
    is_recurring BOOLEAN DEFAULT FALSE,
    recurrence_pattern JSONB, -- {frequency: "weekly", end_date: "2024-12-31", occurrences: 12}
    parent_group_id UUID REFERENCES study_groups(id), -- For recurring sessions
    
    -- Location
    location_type VARCHAR(20) NOT NULL, -- in_person, online, hybrid, tbd
    location_details JSONB,
    -- For in_person: {
    --   building: "Bibliothèque UY1",
    --   room: "Salle 12",
    --   floor: "2nd",
    --   has_electricity: true,
    --   has_wifi: false,
    --   latitude: 3.8667,
    --   longitude: 11.5167,
    --   address: "Ngoa-Ekelle, Yaoundé"
    -- }
    -- For online: {
    --   platform: "zoom",
    --   meeting_link: "https://...",
    --   meeting_id: "123456",
    --   password: "abc123",
    --   requires_camera: false,
    --   data_friendly: true
    -- }
    
    online_platform VARCHAR(50), -- zoom, whatsapp, google_meet, telegram
    online_link TEXT,
    city VARCHAR(100),
    neighborhood VARCHAR(100),
    
    -- Capacity
    max_members INTEGER NOT NULL,
    current_members INTEGER DEFAULT 1,
    min_members INTEGER DEFAULT 2,
    
    -- Access Control
    approval_required BOOLEAN DEFAULT FALSE,
    invitation_only BOOLEAN DEFAULT FALSE,
    password_protected BOOLEAN DEFAULT FALSE,
    access_password VARCHAR(255),
    
    -- Status
    status VARCHAR(20) DEFAULT 'published', -- draft, published, ongoing, completed, cancelled
    cancelled_at TIMESTAMP,
    cancelled_by UUID REFERENCES users(id),
    cancelled_reason TEXT,
    
    -- Completion
    started_at TIMESTAMP,
    completed_at TIMESTAMP,
    attendance_taken BOOLEAN DEFAULT FALSE,
    
    -- Ratings
    avg_rating DECIMAL(3,2),
    total_ratings INTEGER DEFAULT 0,
    avg_productivity DECIMAL(3,2),
    
    -- Materials
    materials JSONB DEFAULT '[]',
    -- Array of: {
    --   id: "uuid",
    --   type: "link" | "file",
    --   title: "...",
    --   url: "...",
    --   required: true
    -- }
    
    -- Rules
    rules TEXT[],
    
    -- Visibility
    visibility VARCHAR(20) DEFAULT 'public', -- public, institution, private
    
    -- Metadata
    metadata JSONB DEFAULT '{}',
    
    -- Timestamps
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP,
    
    -- Constraints
    CONSTRAINT valid_language CHECK (language IN ('fr', 'en', 'both')),
    CONSTRAINT valid_difficulty CHECK (difficulty_level IN ('beginner', 'intermediate', 'advanced', 'mixed')),
    CONSTRAINT valid_location_type CHECK (location_type IN ('in_person', 'online', 'hybrid', 'tbd')),
    CONSTRAINT valid_status CHECK (status IN ('draft', 'published', 'ongoing', 'completed', 'cancelled')),
    CONSTRAINT valid_visibility CHECK (visibility IN ('public', 'institution', 'private')),
    CONSTRAINT valid_capacity CHECK (max_members >= min_members),
    CONSTRAINT valid_members CHECK (current_members <= max_members),
    CONSTRAINT future_date CHECK (date >= CURRENT_DATE OR status != 'published')
);

-- Indexes
CREATE INDEX idx_groups_host ON study_groups(host_user_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_groups_course ON study_groups(course_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_groups_date ON study_groups(date) WHERE deleted_at IS NULL AND status IN ('published', 'ongoing');
CREATE INDEX idx_groups_status ON study_groups(status) WHERE deleted_at IS NULL;
CREATE INDEX idx_groups_city ON study_groups(city) WHERE deleted_at IS NULL;
CREATE INDEX idx_groups_language ON study_groups(language) WHERE deleted_at IS NULL;
CREATE INDEX idx_groups_location_type ON study_groups(location_type) WHERE deleted_at IS NULL;
CREATE INDEX idx_groups_difficulty ON study_groups(difficulty_level) WHERE deleted_at IS NULL;
CREATE INDEX idx_groups_created ON study_groups(created_at DESC) WHERE deleted_at IS NULL;
CREATE INDEX idx_groups_upcoming ON study_groups(date, start_time) 
    WHERE status = 'published' AND date >= CURRENT_DATE AND deleted_at IS NULL;
CREATE INDEX idx_groups_location_details ON study_groups USING GIN(location_details);
CREATE INDEX idx_groups_tags ON study_groups USING GIN(tags);
CREATE INDEX idx_groups_search ON study_groups USING GIN(
    to_tsvector('simple', COALESCE(title, '') || ' ' || COALESCE(description, ''))
);

-- Partial indexes for common queries
CREATE INDEX idx_groups_active_upcoming ON study_groups(date, start_time) 
    WHERE status = 'published' AND deleted_at IS NULL;
CREATE INDEX idx_groups_today ON study_groups(start_time) 
    WHERE date = CURRENT_DATE AND status IN ('published', 'ongoing') AND deleted_at IS NULL;

COMMENT ON TABLE study_groups IS 'Study sessions/groups created by users';
COMMENT ON COLUMN study_groups.recurrence_pattern IS 'JSONB object defining recurrence rules';
COMMENT ON COLUMN study_groups.location_details IS 'JSONB object with location-specific details';

-- ============================================================================
-- 6. GROUP_MEMBERS (Many-to-Many)
-- ============================================================================

CREATE TABLE group_members (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    
    -- Relationships
    group_id UUID NOT NULL REFERENCES study_groups(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    
    -- Status
    status VARCHAR(20) DEFAULT 'joined', -- pending, joined, left, removed, waitlist, declined
    rsvp VARCHAR(20), -- going, maybe, not_going
    
    -- Attendance
    attended BOOLEAN,
    marked_present_at TIMESTAMP,
    marked_present_by UUID REFERENCES users(id),
    arrival_time TIME,
    departure_time TIME,
    
    -- Removal
    removed_by UUID REFERENCES users(id),
    removal_reason TEXT,
    
    -- Waitlist
    waitlist_position INTEGER,
    waitlist_notified BOOLEAN DEFAULT FALSE,
    
    -- Timestamps
    joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    left_at TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Constraints
    UNIQUE(group_id, user_id),
    CONSTRAINT valid_status CHECK (status IN ('pending', 'joined', 'left', 'removed', 'waitlist', 'declined')),
    CONSTRAINT valid_rsvp CHECK (rsvp IN ('going', 'maybe', 'not_going'))
);

-- Indexes
CREATE INDEX idx_members_group ON group_members(group_id);
CREATE INDEX idx_members_user ON group_members(user_id);
CREATE INDEX idx_members_status ON group_members(status);
CREATE INDEX idx_members_rsvp ON group_members(rsvp);
CREATE INDEX idx_members_attended ON group_members(attended);
CREATE INDEX idx_members_joined ON group_members(joined_at DESC);

-- Composite indexes for common queries
CREATE INDEX idx_members_group_status ON group_members(group_id, status);
CREATE INDEX idx_members_user_status ON group_members(user_id, status);
CREATE INDEX idx_members_waitlist ON group_members(group_id, waitlist_position) 
    WHERE status = 'waitlist';

COMMENT ON TABLE group_members IS 'Members of study groups with their participation status';

-- ============================================================================
-- 7. GROUP_MESSAGES
-- ============================================================================

CREATE TABLE group_messages (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    
    -- Relationships
    group_id UUID NOT NULL REFERENCES study_groups(id) ON DELETE CASCADE,
    user_id UUID REFERENCES users(id) ON DELETE SET NULL, -- NULL for system messages
    
    -- Message Content
    content TEXT NOT NULL,
    type VARCHAR(20) DEFAULT 'text', -- text, file, link, image, system
    
    -- Metadata
    metadata JSONB DEFAULT '{}',
    -- For files: {filename, size, mime_type, url}
    -- For links: {url, title, description, image}
    -- For system: {action, data}
    
    -- Reply/Thread
    reply_to UUID REFERENCES group_messages(id),
    thread_id UUID, -- For threaded conversations
    
    -- Reactions
    reactions JSONB DEFAULT '{}',
    -- Structure: {"👍": ["user_id1", "user_id2"], "❤️": ["user_id3"]}
    
    -- Status
    edited BOOLEAN DEFAULT FALSE,
    edited_at TIMESTAMP,
    deleted BOOLEAN DEFAULT FALSE,
    deleted_at TIMESTAMP,
    
    -- Timestamps
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Constraints
    CONSTRAINT valid_type CHECK (type IN ('text', 'file', 'link', 'image', 'system', 'voice'))
);

-- Indexes
CREATE INDEX idx_messages_group ON group_messages(group_id, created_at DESC) WHERE deleted = FALSE;
CREATE INDEX idx_messages_user ON group_messages(user_id) WHERE deleted = FALSE;
CREATE INDEX idx_messages_type ON group_messages(type);
CREATE INDEX idx_messages_created ON group_messages(created_at DESC);
CREATE INDEX idx_messages_thread ON group_messages(thread_id) WHERE thread_id IS NOT NULL;
CREATE INDEX idx_messages_reply ON group_messages(reply_to) WHERE reply_to IS NOT NULL;

-- GIN index for metadata search
CREATE INDEX idx_messages_metadata ON group_messages USING GIN(metadata);

COMMENT ON TABLE group_messages IS 'Chat messages within study groups';

-- ============================================================================
-- 8. MESSAGE_READS
-- ============================================================================

CREATE TABLE message_reads (
    message_id UUID NOT NULL REFERENCES group_messages(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    read_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    PRIMARY KEY (message_id, user_id)
);

-- Indexes
CREATE INDEX idx_reads_user ON message_reads(user_id, read_at DESC);
CREATE INDEX idx_reads_message ON message_reads(message_id);

COMMENT ON TABLE message_reads IS 'Track which users have read which messages';

-- ============================================================================
-- 9. GROUP_MATERIALS
-- ============================================================================

CREATE TABLE group_materials (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    
    -- Relationships
    group_id UUID NOT NULL REFERENCES study_groups(id) ON DELETE CASCADE,
    uploaded_by UUID REFERENCES users(id) ON DELETE SET NULL,
    
    -- File Information
    type VARCHAR(20) NOT NULL, -- file, link
    filename VARCHAR(255),
    original_filename VARCHAR(255),
    s3_key TEXT, -- For files stored in S3
    url TEXT, -- For links or public URLs
    
    -- File Details
    size_bytes BIGINT,
    mime_type VARCHAR(100),
    checksum VARCHAR(64), -- SHA-256
    
    -- Organization
    title VARCHAR(255),
    description TEXT,
    category VARCHAR(50), -- notes, slides, exercises, solutions, reference
    
    -- Access
    access_level VARCHAR(20) DEFAULT 'members', -- members, host_only, public
    download_count INTEGER DEFAULT 0,
    
    -- Status
    active BOOLEAN DEFAULT TRUE,
    
    -- Timestamps
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Constraints
    CONSTRAINT valid_type CHECK (type IN ('file', 'link')),
    CONSTRAINT valid_access CHECK (access_level IN ('members', 'host_only', 'public')),
    CONSTRAINT file_or_link CHECK (
        (type = 'file' AND s3_key IS NOT NULL) OR
        (type = 'link' AND url IS NOT NULL)
    )
);

-- Indexes
CREATE INDEX idx_materials_group ON group_materials(group_id) WHERE active = TRUE;
CREATE INDEX idx_materials_uploader ON group_materials(uploaded_by);
CREATE INDEX idx_materials_type ON group_materials(type);
CREATE INDEX idx_materials_category ON group_materials(category);
CREATE INDEX idx_materials_created ON group_materials(created_at DESC);

COMMENT ON TABLE group_materials IS 'Study materials shared within groups';

-- ============================================================================
-- 10. SESSION_RATINGS
-- ============================================================================

CREATE TABLE session_ratings (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    
    -- Relationships
    group_id UUID NOT NULL REFERENCES study_groups(id) ON DELETE CASCADE,
    rater_user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    
    -- Ratings (1-5 scale)
    overall_rating INTEGER NOT NULL,
    productivity_rating INTEGER NOT NULL,
    organization_rating INTEGER,
    content_quality_rating INTEGER,
    host_rating INTEGER,
    
    -- Feedback
    would_join_again VARCHAR(10), -- yes, maybe, no
    tags TEXT[], -- Quick feedback tags
    -- Examples: ["well_organized", "stayed_on_topic", "good_materials", 
    --            "started_late", "too_many_distractions"]
    comments TEXT,
    
    -- Public/Private
    public BOOLEAN DEFAULT TRUE,
    anonymous BOOLEAN DEFAULT FALSE,
    
    -- Timestamps
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Constraints
    UNIQUE(group_id, rater_user_id),
    CONSTRAINT valid_overall CHECK (overall_rating >= 1 AND overall_rating <= 5),
    CONSTRAINT valid_productivity CHECK (productivity_rating >= 1 AND productivity_rating <= 5),
    CONSTRAINT valid_organization CHECK (organization_rating IS NULL OR (organization_rating >= 1 AND organization_rating <= 5)),
    CONSTRAINT valid_content CHECK (content_quality_rating IS NULL OR (content_quality_rating >= 1 AND content_quality_rating <= 5)),
    CONSTRAINT valid_host CHECK (host_rating IS NULL OR (host_rating >= 1 AND host_rating <= 5)),
    CONSTRAINT valid_would_join CHECK (would_join_again IN ('yes', 'maybe', 'no'))
);

-- Indexes
CREATE INDEX idx_ratings_group ON session_ratings(group_id);
CREATE INDEX idx_ratings_rater ON session_ratings(rater_user_id);
CREATE INDEX idx_ratings_overall ON session_ratings(overall_rating);
CREATE INDEX idx_ratings_created ON session_ratings(created_at DESC);
CREATE INDEX idx_ratings_public ON session_ratings(public) WHERE public = TRUE;

COMMENT ON TABLE session_ratings IS 'Feedback and ratings for completed study sessions';

-- ============================================================================
-- 11. USER_STATS (Denormalized)
-- ============================================================================

CREATE TABLE user_stats (
    user_id UUID PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    
    -- Session Counts
    total_sessions INTEGER DEFAULT 0,
    sessions_hosted INTEGER DEFAULT 0,
    sessions_attended INTEGER DEFAULT 0,
    sessions_completed INTEGER DEFAULT 0,
    sessions_no_show INTEGER DEFAULT 0,
    
    -- Ratings
    avg_rating DECIMAL(3,2),
    total_ratings_received INTEGER DEFAULT 0,
    avg_host_rating DECIMAL(3,2),
    total_host_ratings INTEGER DEFAULT 0,
    
    -- Reliability
    reliability_score INTEGER DEFAULT 100, -- 0-100
    attendance_rate DECIMAL(5,2), -- Percentage
    on_time_rate DECIMAL(5,2),
    
    -- Streaks
    current_streak INTEGER DEFAULT 0,
    longest_streak INTEGER DEFAULT 0,
    last_session_date DATE,
    
    -- Activity
    total_messages_sent INTEGER DEFAULT 0,
    total_files_shared INTEGER DEFAULT 0,
    total_groups_joined INTEGER DEFAULT 0,
    
    -- Contribution
    helpful_count INTEGER DEFAULT 0, -- Times marked as helpful
    
    -- Timestamps
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    stats_calculated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX idx_stats_rating ON user_stats(avg_rating DESC);
CREATE INDEX idx_stats_reliability ON user_stats(reliability_score DESC);
CREATE INDEX idx_stats_sessions ON user_stats(total_sessions DESC);
CREATE INDEX idx_stats_streak ON user_stats(current_streak DESC);

COMMENT ON TABLE user_stats IS 'Denormalized user statistics for performance';

-- ============================================================================
-- 12. NOTIFICATIONS
-- ============================================================================

CREATE TABLE notifications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    
    -- Recipient
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    
    -- Notification Details
    type VARCHAR(50) NOT NULL,
    -- Types: session_starting, session_cancelled, join_approved, new_message,
    --        group_update, payment_success, weekly_digest, etc.
    
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    
    -- Data
    data JSONB DEFAULT '{}',
    -- Context-specific data for rendering notification
    
    -- Delivery
    channel VARCHAR(20), -- sms, whatsapp, email, push, in_app
    sent BOOLEAN DEFAULT FALSE,
    sent_at TIMESTAMP,
    delivery_status VARCHAR(20), -- pending, sent, delivered, failed
    error_message TEXT,
    
    -- Interaction
    read BOOLEAN DEFAULT FALSE,
    read_at TIMESTAMP,
    clicked BOOLEAN DEFAULT FALSE,
    clicked_at TIMESTAMP,
    
    -- Action
    action_url TEXT,
    action_taken BOOLEAN DEFAULT FALSE,
    
    -- Priority
    priority INTEGER DEFAULT 3, -- 1=high, 2=medium, 3=low
    
    -- Batching
    batch_id UUID, -- For batched notifications
    
    -- Expiry
    expires_at TIMESTAMP,
    
    -- Timestamps
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Constraints
    CONSTRAINT valid_channel CHECK (channel IN ('sms', 'whatsapp', 'email', 'push', 'in_app')),
    CONSTRAINT valid_delivery CHECK (delivery_status IN ('pending', 'sent', 'delivered', 'failed', 'cancelled')),
    CONSTRAINT valid_priority CHECK (priority >= 1 AND priority <= 5)
);

-- Indexes
CREATE INDEX idx_notifications_user ON notifications(user_id, created_at DESC);
CREATE INDEX idx_notifications_read ON notifications(user_id, read) WHERE read = FALSE;
CREATE INDEX idx_notifications_type ON notifications(type);
CREATE INDEX idx_notifications_sent ON notifications(sent);
CREATE INDEX idx_notifications_delivery ON notifications(delivery_status);
CREATE INDEX idx_notifications_channel ON notifications(channel);
CREATE INDEX idx_notifications_batch ON notifications(batch_id) WHERE batch_id IS NOT NULL;
CREATE INDEX idx_notifications_pending ON notifications(sent) 
    WHERE sent = FALSE AND delivery_status = 'pending';
CREATE INDEX idx_notifications_expires ON notifications(expires_at) 
    WHERE expires_at IS NOT NULL AND expires_at > NOW();

-- Partial index for unread notifications
CREATE INDEX idx_notifications_unread_recent ON notifications(user_id, created_at DESC) 
    WHERE read = FALSE AND created_at > NOW() - INTERVAL '30 days';

COMMENT ON TABLE notifications IS 'User notifications across all channels';

-- ============================================================================
-- 13. TRANSACTIONS (Payments)
-- ============================================================================

CREATE TABLE transactions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    
    -- User
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE SET NULL,
    
    -- Payment Details
    reference_id VARCHAR(255) UNIQUE NOT NULL, -- From payment provider
    amount DECIMAL(10,2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'XAF',
    
    -- Provider
    provider VARCHAR(20) NOT NULL, -- mtn_momo, orange_money
    provider_transaction_id VARCHAR(255),
    
    -- Status
    status VARCHAR(20) DEFAULT 'pending',
    -- pending, processing, successful, failed, refunded, cancelled
    
    -- Type
    type VARCHAR(50) NOT NULL, -- subscription, one_time, refund
    plan VARCHAR(20), -- monthly, yearly (for subscriptions)
    
    -- Payment Method
    phone_number VARCHAR(20),
    
    -- Metadata
    metadata JSONB DEFAULT '{}',
    description TEXT,
    
    -- Provider Response
    provider_response JSONB,
    error_code VARCHAR(50),
    error_message TEXT,
    
    -- Reconciliation
    reconciled BOOLEAN DEFAULT FALSE,
    reconciled_at TIMESTAMP,
    
    -- Timestamps
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP,
    failed_at TIMESTAMP,
    
    -- Constraints
    CONSTRAINT valid_provider CHECK (provider IN ('mtn_momo', 'orange_money', 'card', 'bank_transfer')),
    CONSTRAINT valid_status CHECK (status IN ('pending', 'processing', 'successful', 'failed', 'refunded', 'cancelled')),
    CONSTRAINT valid_type CHECK (type IN ('subscription', 'one_time', 'refund', 'credit')),
    CONSTRAINT positive_amount CHECK (amount > 0)
);

-- Indexes
CREATE INDEX idx_transactions_user ON transactions(user_id);
CREATE INDEX idx_transactions_reference ON transactions(reference_id);
CREATE INDEX idx_transactions_status ON transactions(status);
CREATE INDEX idx_transactions_provider ON transactions(provider);
CREATE INDEX idx_transactions_created ON transactions(created_at DESC);
CREATE INDEX idx_transactions_pending ON transactions(status) 
    WHERE status IN ('pending', 'processing');

COMMENT ON TABLE transactions IS 'Payment transactions for premium subscriptions';

-- ============================================================================
-- 14. OTP_CODES (Temporary)
-- ============================================================================

CREATE TABLE otp_codes (
    phone VARCHAR(20) PRIMARY KEY,
    code VARCHAR(6) NOT NULL,
    attempts INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP NOT NULL,
    
    -- Constraints
    CONSTRAINT valid_code CHECK (code ~ '^[0-9]{6}$')
);

-- Index for cleanup
CREATE INDEX idx_otp_expires ON otp_codes(expires_at);

COMMENT ON TABLE otp_codes IS 'Temporary OTP codes for phone verification';

-- ============================================================================
-- 15. REFRESH_TOKENS
-- ============================================================================

CREATE TABLE refresh_tokens (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    token TEXT UNIQUE NOT NULL,
    
    -- Device Info
    device_id VARCHAR(255),
    device_name VARCHAR(255),
    device_type VARCHAR(50), -- mobile, desktop, tablet
    user_agent TEXT,
    ip_address INET,
    
    -- Status
    revoked BOOLEAN DEFAULT FALSE,
    revoked_at TIMESTAMP,
    revoked_reason TEXT,
    
    -- Timestamps
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP NOT NULL,
    last_used_at TIMESTAMP
);

-- Indexes
CREATE INDEX idx_refresh_tokens_user ON refresh_tokens(user_id) WHERE revoked = FALSE;
CREATE INDEX idx_refresh_tokens_token ON refresh_tokens(token) WHERE revoked = FALSE;
CREATE INDEX idx_refresh_tokens_expires ON refresh_tokens(expires_at);

-- Cleanup index
CREATE INDEX idx_refresh_tokens_expired ON refresh_tokens(expires_at) 
    WHERE expires_at < NOW() OR revoked = TRUE;

COMMENT ON TABLE refresh_tokens IS 'JWT refresh tokens for authentication';

-- ============================================================================
-- 16. AUDIT_LOGS
-- ============================================================================

CREATE TABLE audit_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    
    -- Actor
    user_id UUID REFERENCES users(id) ON DELETE SET NULL,
    
    -- Action
    action VARCHAR(100) NOT NULL,
    -- Examples: user.created, user.updated, group.created, group.cancelled,
    --           payment.successful, user.banned
    
    -- Resource
    resource_type VARCHAR(50),
    resource_id UUID,
    
    -- Details
    changes JSONB, -- Before/after values
    metadata JSONB DEFAULT '{}',
    
    -- Context
    ip_address INET,
    user_agent TEXT,
    request_id VARCHAR(100),
    
    -- Timestamp
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX idx_audit_user ON audit_logs(user_id, created_at DESC);
CREATE INDEX idx_audit_action ON audit_logs(action);
CREATE INDEX idx_audit_resource ON audit_logs(resource_type, resource_id);
CREATE INDEX idx_audit_created ON audit_logs(created_at DESC);

-- Partition by month for large datasets
-- CREATE TABLE audit_logs_2024_02 PARTITION OF audit_logs
--     FOR VALUES FROM ('2024-02-01') TO ('2024-03-01');

COMMENT ON TABLE audit_logs IS 'Audit trail of important actions';

-- ============================================================================
-- TRIGGERS & FUNCTIONS
-- ============================================================================

-- Auto-update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply to tables with updated_at
CREATE TRIGGER update_institutions_updated_at BEFORE UPDATE ON institutions
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_courses_updated_at BEFORE UPDATE ON courses
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_user_courses_updated_at BEFORE UPDATE ON user_courses
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_study_groups_updated_at BEFORE UPDATE ON study_groups
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_group_members_updated_at BEFORE UPDATE ON group_members
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_group_materials_updated_at BEFORE UPDATE ON group_materials
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_session_ratings_updated_at BEFORE UPDATE ON session_ratings
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_transactions_updated_at BEFORE UPDATE ON transactions
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Update group member count
CREATE OR REPLACE FUNCTION update_group_member_count()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' AND NEW.status = 'joined' THEN
        UPDATE study_groups 
        SET current_members = current_members + 1 
        WHERE id = NEW.group_id;
    ELSIF TG_OP = 'UPDATE' THEN
        IF OLD.status != 'joined' AND NEW.status = 'joined' THEN
            UPDATE study_groups 
            SET current_members = current_members + 1 
            WHERE id = NEW.group_id;
        ELSIF OLD.status = 'joined' AND NEW.status != 'joined' THEN
            UPDATE study_groups 
            SET current_members = current_members - 1 
            WHERE id = NEW.group_id;
        END IF;
    ELSIF TG_OP = 'DELETE' AND OLD.status = 'joined' THEN
        UPDATE study_groups 
        SET current_members = current_members - 1 
        WHERE id = OLD.group_id;
    END IF;
    
    RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER manage_group_member_count
    AFTER INSERT OR UPDATE OR DELETE ON group_members
    FOR EACH ROW EXECUTE FUNCTION update_group_member_count();

-- Update group average rating
CREATE OR REPLACE FUNCTION update_group_rating()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE study_groups
    SET 
        avg_rating = (
            SELECT AVG(overall_rating)
            FROM session_ratings
            WHERE group_id = NEW.group_id
        ),
        total_ratings = (
            SELECT COUNT(*)
            FROM session_ratings
            WHERE group_id = NEW.group_id
        ),
        avg_productivity = (
            SELECT AVG(productivity_rating)
            FROM session_ratings
            WHERE group_id = NEW.group_id
        )
    WHERE id = NEW.group_id;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_group_rating_trigger
    AFTER INSERT OR UPDATE ON session_ratings
    FOR EACH ROW EXECUTE FUNCTION update_group_rating();

-- Update user stats on session completion
CREATE OR REPLACE FUNCTION update_user_stats_on_rating()
RETURNS TRIGGER AS $$
DECLARE
    host_id UUID;
BEGIN
    -- Get host user ID
    SELECT host_user_id INTO host_id
    FROM study_groups
    WHERE id = NEW.group_id;
    
    -- Update host stats
    UPDATE user_stats
    SET
        avg_host_rating = (
            SELECT AVG(sr.host_rating)
            FROM session_ratings sr
            JOIN study_groups sg ON sg.id = sr.group_id
            WHERE sg.host_user_id = host_id AND sr.host_rating IS NOT NULL
        ),
        total_host_ratings = (
            SELECT COUNT(*)
            FROM session_ratings sr
            JOIN study_groups sg ON sg.id = sr.group_id
            WHERE sg.host_user_id = host_id AND sr.host_rating IS NOT NULL
        ),
        updated_at = NOW()
    WHERE user_id = host_id;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_host_stats_on_rating
    AFTER INSERT OR UPDATE ON session_ratings
    FOR EACH ROW EXECUTE FUNCTION update_user_stats_on_rating();

-- Calculate end_time from start_time and duration
CREATE OR REPLACE FUNCTION calculate_end_time()
RETURNS TRIGGER AS $$
BEGIN
    NEW.end_time = (NEW.start_time::TIME + (NEW.duration_minutes || ' minutes')::INTERVAL)::TIME;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER set_group_end_time
    BEFORE INSERT OR UPDATE ON study_groups
    FOR EACH ROW EXECUTE FUNCTION calculate_end_time();

-- Cleanup expired OTP codes
CREATE OR REPLACE FUNCTION cleanup_expired_otps()
RETURNS void AS $$
BEGIN
    DELETE FROM otp_codes WHERE expires_at < NOW();
END;
$$ LANGUAGE plpgsql;

-- Schedule this to run periodically (every hour)
-- SELECT cron.schedule('cleanup-otps', '0 * * * *', 'SELECT cleanup_expired_otps()');

-- ============================================================================
-- INITIAL DATA / SEED
-- ============================================================================

-- Insert default institutions (examples)
INSERT INTO institutions (name, name_fr, name_en, city, region, type, academic_system, verified, active) VALUES
('Université de Yaoundé I', 'Université de Yaoundé I', 'University of Yaoundé I', 'Yaoundé', 'Centre', 'public_university', 'francophone', TRUE, TRUE),
('University of Buea', 'Université de Buea', 'University of Buea', 'Buea', 'South West', 'public_university', 'anglophone', TRUE, TRUE),
('Université de Douala', 'Université de Douala', 'University of Douala', 'Douala', 'Littoral', 'public_university', 'francophone', TRUE, TRUE),
('Université de Dschang', 'Université de Dschang', 'University of Dschang', 'Dschang', 'West', 'public_university', 'francophone', TRUE, TRUE),
('University of Bamenda', 'Université de Bamenda', 'University of Bamenda', 'Bamenda', 'North West', 'public_university', 'anglophone', TRUE, TRUE)
ON CONFLICT DO NOTHING;

-- ============================================================================
-- VIEWS (Optional - for common queries)
-- ============================================================================

-- Active upcoming groups
CREATE VIEW active_upcoming_groups AS
SELECT 
    sg.*,
    u.name as host_name,
    u.profile_photo_url as host_photo,
    c.code as course_code,
    c.name as course_name,
    i.name as institution_name
FROM study_groups sg
JOIN users u ON u.id = sg.host_user_id
LEFT JOIN courses c ON c.id = sg.course_id
LEFT JOIN institutions i ON i.id = u.institution_id
WHERE sg.status = 'published'
  AND sg.date >= CURRENT_DATE
  AND sg.deleted_at IS NULL
ORDER BY sg.date, sg.start_time;

-- User session history
CREATE VIEW user_session_history AS
SELECT 
    gm.user_id,
    sg.id as group_id,
    sg.title,
    sg.date,
    sg.start_time,
    gm.status,
    gm.rsvp,
    gm.attended,
    sr.overall_rating,
    c.name as course_name
FROM group_members gm
JOIN study_groups sg ON sg.id = gm.group_id
LEFT JOIN session_ratings sr ON sr.group_id = gm.group_id AND sr.rater_user_id = gm.user_id
LEFT JOIN courses c ON c.id = sg.course_id
WHERE gm.status IN ('joined', 'left')
  AND sg.deleted_at IS NULL
ORDER BY sg.date DESC, sg.start_time DESC;

-- ============================================================================
-- PERFORMANCE NOTES
-- ============================================================================

-- VACUUM and ANALYZE regularly
-- Consider partitioning large tables (audit_logs, notifications, group_messages)
-- Monitor slow queries with pg_stat_statements
-- Use EXPLAIN ANALYZE for query optimization
-- Consider read replicas for heavy read workloads

COMMENT ON DATABASE studysync IS 'StudySync - Student collaboration platform for Cameroon';
```
