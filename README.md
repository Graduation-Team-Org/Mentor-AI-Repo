
  <h1>Contribution Guidelines</h1>

  <p>Welcome to our repository! To keep our work clean and organized, please follow these simple contribution guidelines:</p>

  <h2>1. Branching Strategy</h2>
  <ul>
    <li><strong>Do not</strong> commit directly to the <code>main</code> branch.</li>
    <li>Always create a new branch from <code>main</code> before you start working.</li>
  </ul>

  <h3>Branch Naming Conventions</h3>
  <p>Use one of the following formats for naming your branch:</p>
  <ul>
    <li><code>feature/feature-name</code> – for new features</li>
    <li><code>bugfix/fix-description</code> – for bug fixes</li>
    <li><code>hotfix/urgent-fix</code> – for urgent issues</li>
    <li><code>refactor/code-cleanup</code> – for code refactoring</li>
    <li><code>docs/update-docs</code> – for documentation updates</li>
  </ul>

  <p>Example:</p>
  <pre><code>git checkout main
git pull origin main
git checkout -b feature/login-screen</code></pre>

  <h2>2. Committing Code</h2>
  <ul>
    <li>Write clear commit messages that describe <strong>what</strong> and <strong>why</strong> the change was made.</li>
  </ul>

  <p>Example:</p>
  <pre><code>git add .
git commit -m "Add validation to login form"
git push origin feature/login-screen</code></pre>

  <h2>3. Creating Pull Requests (PRs)</h2>
  <ul>
    <li>After pushing your branch, go to GitHub and open a Pull Request (PR) from your branch to <code>main</code>.</li>
    <li>Make sure your code is tested and reviewed by at least one team member.</li>
    <li>Add a short description in the PR explaining your changes.</li>
  </ul>

  <h2>4. Code Review & Merge</h2>
  <ul>
    <li>Never merge your own PR without review.</li>
    <li>When reviewing someone else's code:
      <ul>
        <li>Check for logic errors, styling, and improvements.</li>
        <li>Leave comments or approve the PR when ready.</li>
      </ul>
    </li>
  </ul>

  <h2>5. General Rules</h2>
  <ul>
    <li>Keep commits focused and small.</li>
    <li>Keep the code clean and readable.</li>
    <li>Ask questions if you're unsure before pushing changes.</li>
  </ul>

  <p><strong>Happy coding!</strong></p>

