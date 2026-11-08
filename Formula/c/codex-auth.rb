class CodexAuth < Formula
  desc "Switch and manage Codex accounts from the terminal"
  homepage "https://github.com/loongphy/codex-auth"
  url "https://github.com/loongphy/codex-auth/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "5984a6a9cb41ce10091efdc3c146f7accec26439a7b43d209e44b1afa6c7016e"
  license "MIT"
  head "https://github.com/loongphy/codex-auth.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "706c124570886aa447b32ff5ab16a1f497f184906851f6483be786b6945c1f34"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80f8547936be07b6e293752a5054b33b771e69c31cc4dc18e21902b5fce20de2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "12d89eda0ead6b5e8b9b2ec2a4c02bf8a57436f4f4748039a91cb87396897dbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd96b3be7ad40cf18f78b31c2d9b91fe1270287c8cff39c3703c339a43fa3c1c"
  end

  depends_on "zig" => :build
  depends_on "curl"
  depends_on "node"

  deny_network_access!

  def install
    system "zig", "build", "-Doptimize=ReleaseSafe", "--prefix", libexec
    (bin/"codex-auth").write_env_script libexec/"bin/codex-auth",
      CODEX_AUTH_NODE_EXECUTABLE: formula_opt_bin("node")/"node",
      PATH:                       "#{formula_opt_bin("curl")}:$PATH"

    generate_completions_from_executable(bin/"codex-auth", "completion")
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
