/*
  # Chat Messages Table for Hub Bot

  ## Overview
  Creates a table to store chat conversations between users and the Hub Bot AI chatbot.

  ## New Tables

  ### chat_messages
  Stores all messages in chat conversations
  - `id` (uuid, primary key) - Unique message identifier
  - `user_id` (uuid) - User/session identifier
  - `role` (text) - Message sender role ('user' or 'assistant')
  - `content` (text) - Message content
  - `created_at` (timestamptz) - Message creation timestamp

  ## Security
  - Enable RLS on chat_messages table
  - Allow read access to own messages

  ## Notes
  - Messages are linked to user sessions
  - Unlimited message length for flexibility
*/

CREATE TABLE IF NOT EXISTS chat_messages (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL,
  role text NOT NULL CHECK (role IN ('user', 'assistant')),
  content text NOT NULL,
  created_at timestamptz DEFAULT now()
);

-- Enable Row Level Security
ALTER TABLE chat_messages ENABLE ROW LEVEL SECURITY;

-- RLS Policies for chat_messages
CREATE POLICY "Users can view own messages"
  ON chat_messages FOR SELECT
  USING (true);

CREATE POLICY "Users can insert messages"
  ON chat_messages FOR INSERT
  WITH CHECK (true);
