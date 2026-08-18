export type LiveGameStatus =
  | "lobby"
  | "question"
  | "reveal"
  | "finished";

export type LiveQuestion = {
  id: string;
  grade: number;
  topic: string;
  prompt: string;
  promptEs: string;
  choices: string[];
  choicesEs: string[];
  correctIndex: number;
  explanation: string;
  explanationEs: string;
  seconds: number;
};

export type LiveGame = {
  id: string;
  pin: string;
  grade: number;
  title: string;
  status: LiveGameStatus;
  current_question_index: number;
  question_started_at: string | null;
  created_at: string;
};

export type LivePlayer = {
  id: string;
  game_id: string;
  name: string;
  avatar?: string;
  score: number;
  streak: number;
  joined_at: string;
};

export type LiveAnswer = {
  id: string;
  game_id: string;
  player_id: string;
  question_index: number;
  answer_index: number;
  is_correct: boolean;
  response_ms: number;
  points: number;
  created_at: string;
};
