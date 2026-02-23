import { Client } from 'pg';
import fs from 'fs';
import path from 'path';
import dotenv from 'dotenv';

// Load environment variables
dotenv.config({ path: path.resolve(process.cwd(), '.env') });

async function runMigrations() {
    console.log('Starting execution of database migrations...');

    // Check if DATABASE_URL is somehow given, otherwise use defaults
    const client = new Client({
        connectionString: process.env.DATABASE_URL || 'postgresql://postgres:postgres@localhost:5432/studysync'
    });

    try {
        await client.connect();
        console.log('Successfully connected to the database.');

        const migrationsDir = path.resolve(__dirname, 'migrations');
        if (!fs.existsSync(migrationsDir)) {
            console.log('No migrations directory found.');
            return;
        }

        const files = fs.readdirSync(migrationsDir).filter((f: string) => f.endsWith('.sql')).sort();

        for (const file of files) {
            console.log(`Running migration file: ${file}`);
            const filePath = path.join(migrationsDir, file);
            const sql = fs.readFileSync(filePath, 'utf-8');

            // Execute the schema SQL
            await client.query("BEGIN");
            try {
                await client.query(sql);
                await client.query("COMMIT");
                console.log(`Successfully completed migration: ${file}`);
            } catch (queryErr) {
                await client.query("ROLLBACK");
                throw queryErr;
            }
        }

        console.log('All migrations executed successfully!');
    } catch (error) {
        console.error('Migration failed with error:', error);
        process.exit(1);
    } finally {
        await client.end();
    }
}

runMigrations();
