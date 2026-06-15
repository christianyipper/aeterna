'use client'

import { useState } from 'react'
import { useRouter } from 'next/navigation'

export default function LoginPage() {
  const router = useRouter()
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [error, setError] = useState<string | null>(null)

  function handleSubmit(e: React.FormEvent) {
    e.preventDefault()
    if (email === 'guest' && password === 'guest') {
      setError(null)
      router.push('/home')
    } else {
      setError('Invalid email or password.')
    }
  }

  return (
    <main className="min-h-screen bg-[#080808] flex items-center justify-center px-4">
      <div className="w-full max-w-sm space-y-12">

        {/* Title */}
        <div className="text-center space-y-3">
          <h1 className="text-6xl font-extralight tracking-[0.4em] text-white uppercase">
            Aeterna
          </h1>
          <p className="text-[10px] tracking-[0.35em] text-neutral-500 uppercase">
            Train with intention
          </p>
        </div>

        {/* Divider */}
        <div className="h-px bg-neutral-800" />

        {/* Form */}
        <form onSubmit={handleSubmit} className="space-y-4">
          <input
            type="text"
            placeholder="Email or username"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            required
            className="w-full bg-neutral-900 border border-neutral-800 text-white placeholder-neutral-600 px-4 py-3.5 text-sm focus:outline-none focus:border-neutral-500 transition-colors"
          />
          <input
            type="password"
            placeholder="Password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            required
            className="w-full bg-neutral-900 border border-neutral-800 text-white placeholder-neutral-600 px-4 py-3.5 text-sm focus:outline-none focus:border-neutral-500 transition-colors"
          />

          <div className="pt-2 space-y-3">
            <button
              type="submit"
              className="w-full bg-white text-black text-xs tracking-[0.25em] uppercase py-3.5 hover:bg-neutral-200 transition-colors font-medium cursor-pointer"
            >
              Sign In
            </button>
            {error && (
              <p className="text-xs text-red-400 tracking-wide text-center">{error}</p>
            )}
          </div>
        </form>

        {/* Footer */}
        <p className="text-center text-xs text-neutral-600 tracking-wide">
          No account?{' '}
          <a
            href="#"
            className="text-neutral-400 hover:text-white transition-colors hover:underline underline-offset-4"
          >
            Create one
          </a>
        </p>

      </div>
    </main>
  )
}
