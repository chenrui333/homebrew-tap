class CodexAuth < Formula
  desc "Switch and manage Codex accounts from the terminal"
  homepage "https://github.com/loongphy/codex-auth"
  url "https://github.com/loongphy/codex-auth/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "d5a8b3eedb3130afe27ddb867347abf38693f23bdac39ada8dd588b42c28622b"
  license "MIT"
  head "https://github.com/loongphy/codex-auth.git", branch: "main"

  depends_on "zig@0.16" => :build
  depends_on "curl"
  depends_on "node"

  deny_network_access!

  def install
    system "zig", "build", "-Doptimize=ReleaseSafe", "--prefix", libexec
    (bin/"codex-auth").write_env_script libexec/"bin/codex-auth",
      CODEX_AUTH_NODE_EXECUTABLE: formula_opt_bin("node")/"node",
      PATH:                       "#{formula_opt_bin("curl")}:$PATH"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/codex-auth --version")
    ENV["CODEX_HOME"] = testpath/"codex"
    (testpath/"codex").mkpath
    account_id = "67000000-0000-4000-8000-000000000001"
    payload = {
      email:                         "brew@example.com",
      "https://api.openai.com/auth": {
        chatgpt_account_id: account_id,
        chatgpt_user_id:    "user-homebrew-fixture",
        chatgpt_plan_type:  "plus",
      },
    }
    encoded = [JSON.generate(payload)].pack("m0").tr("+/", "-_").delete("=")
    # Unsigned, nonsecret fixture: no API refresh or real authentication is performed.
    (testpath/"codex/auth.json").write JSON.generate(
      tokens: { id_token: "eyJhbGciOiJub25lIn0.#{encoded}.sig", account_id: },
    )
    result = JSON.parse(shell_output("#{bin}/codex-auth list --skip-api --json"))
    account = result.fetch("accounts").fetch(0)
    assert_equal "brew@example.com", account.fetch("email")
    assert_equal "user-homebrew-fixture::#{account_id}", account.fetch("account_key")
    assert_equal account.fetch("account_key"), result.fetch("active_account_key")
  end
end
