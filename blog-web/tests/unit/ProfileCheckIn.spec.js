jest.mock('@/api/user', () => ({
  signInApi: jest.fn(() => Promise.resolve({ code: 200, data: { status: 'success' } }))
}))

const mockEmit = jest.fn()
jest.mock('@/utils/theme', () => ({
  themeBus: {
    $emit: (...args) => mockEmit(...args),
    $on: jest.fn(),
    $off: jest.fn()
  }
}))

import Profile from '@/views/profile/index.vue'
import { signInApi } from '@/api/user'

describe('Profile check-in logic', () => {
  beforeEach(() => {
    mockEmit.mockClear()
    localStorage.clear()
  })

  it('calls signInApi and updates reminder state on success', async () => {
    const ctx = {
      signInStatus: false,
      signInLoading: false,
      $message: {
        success: jest.fn(),
        error: jest.fn()
      },
      refreshSignInInfo: jest.fn(() => Promise.resolve()),
      handleCheckInSuccess: jest.fn(),
      extractSignInDone: Profile.methods.extractSignInDone
    }

    Profile.methods.handleSignIn.call(ctx)
    await Promise.resolve()
    await Promise.resolve()

    expect(signInApi).toHaveBeenCalled()
    expect(ctx.handleCheckInSuccess).toHaveBeenCalled()
    expect(ctx.$message.success).toHaveBeenCalled()
  })

  it('shows red dot when today not signed in', () => {
    const ctx = {
      signInStatus: { hasSignedIn: false },
      showCalendarBadge: false,
      extractSignInDone: Profile.methods.extractSignInDone
    }

    Profile.methods.syncCalendarBadge.call(ctx)

    expect(ctx.showCalendarBadge).toBe(true)
    expect(mockEmit).toHaveBeenCalledWith('calendar-reminder-update', true)
  })
})
