import os

with open('/home/ace/Projects/Study-Sync/database-design.md', 'r') as f:
    lines = f.readlines()

in_sql = False
sql = []
for line in lines:
    if line.strip() == '```sql':
        in_sql = True
        continue
    if in_sql and line.strip() == '```':
        break
    if in_sql:
        sql.append(line)

os.makedirs('/home/ace/Projects/Study-Sync/studysync-backend/scripts/migrations', exist_ok=True)
with open('/home/ace/Projects/Study-Sync/studysync-backend/scripts/migrations/001_initial_schema.sql', 'w') as f:
    f.writelines(sql)

print("Done")
