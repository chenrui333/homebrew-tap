class ContinueCli < Formula
  desc "AI coding assistant for the terminal"
  homepage "https://continue.dev/"
  url "https://registry.npmjs.org/@continuedev/cli/-/cli-1.5.47.tgz"
  sha256 "bcf43fd5db041dbff4ee2eb9639a8cc732eba5d7f5ea137c0ef2025976fa3724"
  license "Apache-2.0"

  depends_on "node"

  deny_network_access!

  def fetch
    system "npm", "install", "--global", "--prefix", buildpath/"npm-fetch",
                             *std_npm_args(prefix: false), cached_download
  end

  def install
    rm_r "npm-fetch"
    system "npm", "install", "--offline", "--global", "--prefix", libexec,
                             *std_npm_args(prefix: false), cached_download
    bin.install_symlink libexec/"bin/cn"
  end

  test do
    ENV["CONTINUE_GLOBAL_DIR"] = testpath/".continue"
    sessions = testpath/".continue/sessions"
    sessions.mkpath
    metadata = { sessionId: "brew-test", title: "Homebrew session", workspaceDirectory: testpath.to_s }
    (sessions/"sessions.json").write JSON.generate([metadata])
    history = [{ message: { role: "user", content: "Offline fixture" } }]
    (sessions/"brew-test.json").write JSON.generate(metadata.merge(history:))

    entries = JSON.parse(shell_output("#{bin}/cn ls --json")).fetch("sessions")
    assert_equal [["brew-test", "Homebrew session", "Offline fixture"]],
                 entries.map { |session| session.values_at("id", "title", "firstUserMessage") }
  end
end
