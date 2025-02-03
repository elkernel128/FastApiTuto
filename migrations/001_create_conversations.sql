create table conversations (
    id bigint primary key generated always as identity,
    user_id text not null,
    message text not null,
    response text not null,
    created_at timestamptz default now() not null
);

-- Create an index for faster searching
create index idx_conversations_user_id_message on conversations (user_id, message); 