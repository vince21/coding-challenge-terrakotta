import React, { useState } from 'react'
import './App.css'

interface TestCase {
  name: string
  address: string
}

function App() {
  const [name, setName] = useState('')
  const [address, setAddress] = useState('')
  const [result, setResult] = useState<any>(null)
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const [testCases, setTestCases] = useState<any>(null)

  // TODO: Implement form submission
  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    setLoading(true)
    setError(null)
    
    try {
      // TODO: Call the backend /normalize endpoint
      // TODO: Handle the response properly
      // TODO: Display structured data nicely
      
      const response = await fetch('/api/normalize', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ name, address })
      })
      
      const data = await response.json()
      
      if (!response.ok) {
        throw new Error(data.error || 'Failed to normalize')
      }
      
      setResult(data)
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Something went wrong')
    } finally {
      setLoading(false)
    }
  }

  // Load test cases
  const loadTestCases = async () => {
    try {
      const response = await fetch('/api/test-cases')
      const data = await response.json()
      setTestCases(data)
    } catch (err) {
      console.error('Failed to load test cases')
    }
  }

  React.useEffect(() => {
    loadTestCases()
  }, [])

  const applyTestCase = (testCase: TestCase) => {
    setName(testCase.name)
    setAddress(testCase.address)
    setResult(null)
    setError(null)
  }

  return (
    <div className="container">
      <div className="card">
        <h1>🏠 Address Normalizer</h1>
        <p className="subtitle">Enter a name and address to normalize into structured data</p>

        <form onSubmit={handleSubmit} className="form">
          <div className="form-group">
            <label htmlFor="name">Name</label>
            <input
              id="name"
              type="text"
              value={name}
              onChange={(e) => setName(e.target.value)}
              placeholder="e.g., John Smith or María García-López"
              required
            />
          </div>

          <div className="form-group">
            <label htmlFor="address">Address</label>
            <input
              id="address"
              type="text"
              value={address}
              onChange={(e) => setAddress(e.target.value)}
              placeholder="e.g., 123 Main St Apt 4B, Seattle, WA 98101"
              required
            />
          </div>

          <button type="submit" disabled={loading} className="submit-btn">
            {loading ? 'Normalizing...' : 'Normalize Address'}
          </button>
        </form>

        {/* Test Cases */}
        {testCases && (
          <div className="test-cases">
            <h3>Quick Test Cases:</h3>
            <div className="test-case-grid">
              {Object.entries(testCases).map(([level, cases]: [string, any]) => (
                <div key={level} className="test-case-section">
                  <h4>{level.charAt(0).toUpperCase() + level.slice(1)}</h4>
                  {cases.map((tc: TestCase, idx: number) => (
                    <button
                      key={idx}
                      onClick={() => applyTestCase(tc)}
                      className="test-case-btn"
                      title={`${tc.name} - ${tc.address}`}
                    >
                      {tc.name.split(' ')[0]}
                    </button>
                  ))}
                </div>
              ))}
            </div>
          </div>
        )}

        {/* Error Display */}
        {error && (
          <div className="error">
            ⚠️ {error}
          </div>
        )}

        {/* Result Display */}
        {result && (
          <div className="result">
            <h2>Normalized Result</h2>
            {/* TODO: Make this display better! */}
            {/* Consider showing person and address in a nice format */}
            {/* Show confidence scores if available */}
            <pre>{JSON.stringify(result, null, 2)}</pre>
          </div>
        )}

        <div className="hint">
          💡 <strong>Hint:</strong> The backend currently has a broken prompt. 
          Fix it to return consistent, structured data!
        </div>
      </div>
    </div>
  )
}

export default App