'use client'

import { useState } from 'react'

interface WorkoutCalendarProps {
  loggedDates: string[]   // 'YYYY-MM-DD'
  shieldDates: string[]   // 'YYYY-MM-DD'
}

const DAY_LABELS = ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa']

const MONTH_NAMES = [
  'January', 'February', 'March', 'April', 'May', 'June',
  'July', 'August', 'September', 'October', 'November', 'December',
]

function toDateStr(year: number, month: number, day: number): string {
  return `${year}-${String(month + 1).padStart(2, '0')}-${String(day).padStart(2, '0')}`
}

export default function WorkoutCalendar({ loggedDates, shieldDates }: WorkoutCalendarProps) {
  const today = new Date()
  const [viewYear, setViewYear] = useState(today.getFullYear())
  const [viewMonth, setViewMonth] = useState(today.getMonth())

  const logged = new Set(loggedDates)
  const shielded = new Set(shieldDates)
  const todayStr = toDateStr(today.getFullYear(), today.getMonth(), today.getDate())

  const firstDayOfMonth = new Date(viewYear, viewMonth, 1).getDay()
  const daysInMonth = new Date(viewYear, viewMonth + 1, 0).getDate()

  function prevMonth() {
    if (viewMonth === 0) { setViewMonth(11); setViewYear(y => y - 1) }
    else setViewMonth(m => m - 1)
  }

  function nextMonth() {
    if (viewMonth === 11) { setViewMonth(0); setViewYear(y => y + 1) }
    else setViewMonth(m => m + 1)
  }

  const cells: (number | null)[] = [
    ...Array(firstDayOfMonth).fill(null),
    ...Array.from({ length: daysInMonth }, (_, i) => i + 1),
  ]

  // Pad to full rows
  while (cells.length % 7 !== 0) cells.push(null)

  return (
    <div className="space-y-4">
      {/* Month navigation */}
      <div className="flex items-center justify-between">
        <button
          onClick={prevMonth}
          className="text-neutral-500 hover:text-white transition-colors p-1 cursor-pointer"
          aria-label="Previous month"
        >
          ‹
        </button>
        <span className="text-xs tracking-[0.25em] text-neutral-400 uppercase">
          {MONTH_NAMES[viewMonth]} {viewYear}
        </span>
        <button
          onClick={nextMonth}
          className="text-neutral-500 hover:text-white transition-colors p-1 cursor-pointer"
          aria-label="Next month"
        >
          ›
        </button>
      </div>

      {/* Day labels */}
      <div className="grid grid-cols-7 mb-1">
        {DAY_LABELS.map(d => (
          <div key={d} className="text-center text-[10px] tracking-widest text-neutral-600 uppercase py-1">
            {d}
          </div>
        ))}
      </div>

      {/* Day cells */}
      <div className="grid grid-cols-7 gap-y-1">
        {cells.map((day, i) => {
          if (day === null) return <div key={`empty-${i}`} />

          const dateStr = toDateStr(viewYear, viewMonth, day)
          const isToday = dateStr === todayStr
          const isLogged = logged.has(dateStr)
          const isShielded = shielded.has(dateStr)

          return (
            <div key={dateStr} className="flex items-center justify-center py-0.5">
              <div
                className={[
                  'w-8 h-8 flex items-center justify-center text-xs rounded-full transition-colors',
                  isLogged
                    ? 'bg-white text-black font-medium'
                    : isShielded
                    ? 'bg-amber-500/20 text-amber-400 ring-1 ring-amber-500/40'
                    : isToday
                    ? 'ring-1 ring-neutral-500 text-neutral-300'
                    : 'text-neutral-600',
                ].join(' ')}
              >
                {day}
              </div>
            </div>
          )
        })}
      </div>
    </div>
  )
}
