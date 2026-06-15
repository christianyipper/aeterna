export type Json = string | number | boolean | null | { [key: string]: Json } | Json[]

export type FrictionLevel = 0 | 1 | 2
export type WorkoutStatus = 'planned' | 'in_progress' | 'completed' | 'skipped'
export type ExerciseCategory = 'strength' | 'mobility' | 'stability' | 'prep'
export type BodyRegionCategory = 'upper_body' | 'core' | 'lower_body'
export type BodyRegionSide = 'left' | 'right' | 'center'
export type ActionType = 'inject_exercise' | 'load_ceiling'
export type StreakEventType = 'workout_completed' | 'rest_shield_earned' | 'rest_shield_used' | 'streak_broken'

export interface Database {
  public: {
    Tables: {
      profiles: {
        Row: {
          id: string
          username: string | null
          created_at: string
          updated_at: string
        }
        Insert: {
          id: string
          username?: string | null
          created_at?: string
          updated_at?: string
        }
        Update: {
          username?: string | null
          updated_at?: string
        }
      }
      body_regions: {
        Row: {
          region_key: string
          label: string
          side: BodyRegionSide | null
          category: BodyRegionCategory
        }
        Insert: {
          region_key: string
          label: string
          side?: BodyRegionSide | null
          category: BodyRegionCategory
        }
        Update: never
      }
      body_map_sessions: {
        Row: {
          id: string
          user_id: string
          session_date: string
          created_at: string
        }
        Insert: {
          id?: string
          user_id: string
          session_date?: string
          created_at?: string
        }
        Update: never
      }
      body_map_entries: {
        Row: {
          id: string
          session_id: string
          region_key: string
          friction_level: FrictionLevel
        }
        Insert: {
          id?: string
          session_id: string
          region_key: string
          friction_level: FrictionLevel
        }
        Update: {
          friction_level?: FrictionLevel
        }
      }
      exercises: {
        Row: {
          id: string
          name: string
          category: ExerciseCategory
          muscle_groups: string[]
          is_prep_protocol: boolean
          default_sets: number
          default_reps: number
          default_weight_kg: number | null
          created_at: string
        }
        Insert: {
          id?: string
          name: string
          category: ExerciseCategory
          muscle_groups?: string[]
          is_prep_protocol?: boolean
          default_sets?: number
          default_reps?: number
          default_weight_kg?: number | null
          created_at?: string
        }
        Update: {
          name?: string
          category?: ExerciseCategory
          muscle_groups?: string[]
          is_prep_protocol?: boolean
          default_sets?: number
          default_reps?: number
          default_weight_kg?: number | null
        }
      }
      friction_rules: {
        Row: {
          id: number
          region_key: string
          friction_threshold: 1 | 2
          action_type: ActionType
          exercise_id: string | null
          load_ceiling_pct: number | null
        }
        Insert: {
          region_key: string
          friction_threshold: 1 | 2
          action_type: ActionType
          exercise_id?: string | null
          load_ceiling_pct?: number | null
        }
        Update: never
      }
      workouts: {
        Row: {
          id: string
          user_id: string
          body_map_session_id: string | null
          workout_date: string
          status: WorkoutStatus
          created_at: string
        }
        Insert: {
          id?: string
          user_id: string
          body_map_session_id?: string | null
          workout_date?: string
          status?: WorkoutStatus
          created_at?: string
        }
        Update: {
          body_map_session_id?: string | null
          status?: WorkoutStatus
        }
      }
      workout_exercises: {
        Row: {
          id: string
          workout_id: string
          exercise_id: string
          order_index: number
          suggested_sets: number
          suggested_reps: number
          suggested_weight_kg: number | null
          load_ceiling_applied: boolean
          is_injected: boolean
          completed: boolean
        }
        Insert: {
          id?: string
          workout_id: string
          exercise_id: string
          order_index: number
          suggested_sets: number
          suggested_reps: number
          suggested_weight_kg?: number | null
          load_ceiling_applied?: boolean
          is_injected?: boolean
          completed?: boolean
        }
        Update: {
          order_index?: number
          suggested_sets?: number
          suggested_reps?: number
          suggested_weight_kg?: number | null
          load_ceiling_applied?: boolean
          is_injected?: boolean
          completed?: boolean
        }
      }
      exercise_sets: {
        Row: {
          id: string
          workout_exercise_id: string
          set_number: number
          actual_reps: number | null
          actual_weight_kg: number | null
          completed_at: string | null
        }
        Insert: {
          id?: string
          workout_exercise_id: string
          set_number: number
          actual_reps?: number | null
          actual_weight_kg?: number | null
          completed_at?: string | null
        }
        Update: {
          actual_reps?: number | null
          actual_weight_kg?: number | null
          completed_at?: string | null
        }
      }
      user_streaks: {
        Row: {
          user_id: string
          current_streak: number
          longest_streak: number
          last_activity_date: string | null
          rest_shield_tokens: number
          updated_at: string
        }
        Insert: {
          user_id: string
          current_streak?: number
          longest_streak?: number
          last_activity_date?: string | null
          rest_shield_tokens?: number
          updated_at?: string
        }
        Update: {
          current_streak?: number
          longest_streak?: number
          last_activity_date?: string | null
          rest_shield_tokens?: number
        }
      }
      streak_events: {
        Row: {
          id: string
          user_id: string
          event_type: StreakEventType
          event_date: string
          created_at: string
        }
        Insert: {
          id?: string
          user_id: string
          event_type: StreakEventType
          event_date?: string
          created_at?: string
        }
        Update: never
      }
    }
  }
}
