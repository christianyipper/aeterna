'use client'

import { useState } from 'react'
import Link from 'next/link'
import { useRouter } from 'next/navigation'
import WorkoutCalendar from '@/components/WorkoutCalendar'

// Mock data — replaced when Supabase is connected
const MOCK_LOGGED_DATES = [
  '2026-06-01',
  '2026-06-03',
  '2026-06-05',
  '2026-06-06',
  '2026-06-08',
  '2026-06-09',
  '2026-06-10',
  '2026-06-11',
  '2026-06-12',
  '2026-06-13',
  '2026-06-14',
]
const MOCK_SHIELD_DATES = ['2026-06-04', '2026-06-07']
const MOCK_STREAK = 7
const MOCK_SHIELD_TOKENS = 2

export default function HomePage() {
  const router = useRouter()
  const [shieldTokens, setShieldTokens] = useState(MOCK_SHIELD_TOKENS)
  const [shieldUsedToday, setShieldUsedToday] = useState(false)
  const [shieldDates, setShieldDates] = useState<string[]>(MOCK_SHIELD_DATES)

  function useShield() {
    if (shieldTokens < 1 || shieldUsedToday) return
    const today = new Date()
    const dateStr = `${today.getFullYear()}-${String(today.getMonth() + 1).padStart(2, '0')}-${String(today.getDate()).padStart(2, '0')}`
    setShieldTokens(t => t - 1)
    setShieldUsedToday(true)
    setShieldDates(d => [...d, dateStr])
  }

  return (
    <main className="min-h-screen bg-[#080808] flex flex-col px-6 py-10 max-w-sm mx-auto">

      {/* Header */}
      <div className="flex items-center justify-between mb-10">
        <span className="text-xs tracking-[0.35em] text-neutral-500 uppercase">Aeterna</span>
        <button
          onClick={() => router.push('/')}
          className="text-xs tracking-[0.25em] text-neutral-600 uppercase hover:text-white transition-colors cursor-pointer"
        >
          Logout
        </button>
      </div>

      {/* Streak */}
      <div className="mb-10">
        <p className="text-[10px] tracking-[0.3em] text-neutral-500 uppercase mb-1">Current Streak</p>
        <h1 className="text-5xl font-extralight text-white tracking-tight">
          {MOCK_STREAK} <span className="text-2xl text-neutral-400">days</span>
        </h1>
      </div>

      {/* Calendar */}
      <div className="bg-neutral-900/50 border border-neutral-800 p-5 mb-10">
        <WorkoutCalendar
          loggedDates={MOCK_LOGGED_DATES}
          shieldDates={shieldDates}
        />
      </div>

      {/* Actions */}
      <div className="space-y-3 mt-auto">

        {/* Shield */}
        <button
          onClick={useShield}
          disabled={shieldTokens < 1 || shieldUsedToday}
          className={[
            'w-full py-3.5 text-xs tracking-[0.25em] uppercase transition-colors border cursor-pointer',
            shieldUsedToday
              ? 'border-amber-500/30 text-amber-500/50 cursor-not-allowed'
              : shieldTokens < 1
              ? 'border-neutral-800 text-neutral-700 cursor-not-allowed'
              : 'border-amber-500/50 text-amber-400 hover:bg-amber-500/10',
          ].join(' ')}
        >
          {shieldUsedToday ? 'Shield Active Today' : `Use Shield  ·  ${shieldTokens} remaining`}
        </button>

        {/* Start Workout */}
        <Link
          href="/workout"
          className="block w-full bg-white text-black text-xs tracking-[0.25em] uppercase py-3.5 text-center hover:bg-neutral-200 transition-colors font-medium"
        >
          Start Workout
        </Link>

        {/* Body Map */}
        <Link
          href="/body-map"
          className="block w-full border border-neutral-800 text-neutral-400 text-xs tracking-[0.25em] uppercase py-3.5 text-center hover:border-neutral-600 hover:text-white transition-colors"
        >
          Resistance Map
        </Link>

      </div>
    </main>
  )
}
