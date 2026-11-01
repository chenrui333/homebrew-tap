class Luvus < Formula
  desc "Mission control for AI coding agents"
  homepage "https://luvus.dev"
  url "https://github.com/RizRiyz/luvus/archive/refs/tags/v0.14.3.tar.gz"
  sha256 "d51e053d2eccc339fa7a60474de8026b7bcf1b3553402991736f22be0926e3b4"
  license "Apache-2.0"
  head "https://github.com/RizRiyz/luvus.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d07c4ce4f716eb3825decd3816715d8df601bd7e49902c09f01cc1a979a3f6e7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3054d5f9727b6d7dc84b40ca0029a106c19a01803276f87588ff42fc228e6609"
    sha256 cellar: :any,                 arm64_linux:   "34a4f965bf33e223ba4df0e99fd2517a0bb925e23fc51fb18472cd41cc18b734"
    sha256 cellar: :any,                 x86_64_linux:  "71fce1ed693f1e5df3a3372d81a76ec4bdbd676d9ade73b6351b502bf284e1fe"
  end

  depends_on "node" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "bash"
  depends_on "coreutils"
  depends_on "gh"
  depends_on "openssh"
  depends_on "sqlite"

  on_linux do
    depends_on "procps"
  end

  # Cargo and npm fetch dependencies while compiling the terminal and embedded web UI.
  allow_network_access! :build

  def install
    ENV["LIBSQLITE3_SYS_USE_PKG_CONFIG"] = "1"
    cd "web" do
      system "npm", "ci"
      system "npm", "run", "build:native"
    end
    system "cargo", "install", *std_cargo_args
  end

  service do
    # Bare server is upstream's foreground Unix-IPC role, not the attaching TUI.
    run [opt_bin/"luvus", "server"]
    keep_alive true
    log_path var/"log/luvus.log"
    error_log_path var/"log/luvus.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/luvus --version")
    output = JSON.parse(shell_output("#{bin}/luvus session stop ../outside --json", 1))
    assert_equal "invalid_session_name", output.fetch("error").fetch("code")
  end
end
