class ContinueCli < Formula
  desc "AI coding assistant for the terminal"
  homepage "https://continue.dev/"
  url "https://registry.npmjs.org/@continuedev/cli/-/cli-1.5.47.tgz"
  sha256 "bcf43fd5db041dbff4ee2eb9639a8cc732eba5d7f5ea137c0ef2025976fa3724"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "2e72488eeffbef1145a686fe4e1dcd653634765a777a1fe0c57bc3a6ddd9bbe0"
    sha256 cellar: :any, arm64_tahoe:   "bfa81c2664dcb80d1d953052ca8214811fee9b6180c376659a52f3e16d73d886"
    sha256 cellar: :any, arm64_sequoia: "bfa81c2664dcb80d1d953052ca8214811fee9b6180c376659a52f3e16d73d886"
    sha256 cellar: :any, arm64_linux:   "6d5db5477abaaa977d3c559e3802db5bf0d760b97fe681003f0864771fe699db"
    sha256 cellar: :any, x86_64_linux:  "f689522ec095c6a51290389fb6f24484ac8c48b1a5bc9ff2aa1a92e446e9115e"
  end

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
