class Tuios < Formula
  desc "Terminal UI OS (Terminal Multiplexer)"
  homepage "https://github.com/Gaurav-Gosain/tuios"
  url "https://github.com/Gaurav-Gosain/tuios/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "dbe683cd8c3758a613e9d871a8ea9321c6f86bfe4cd6ba44aef8cca6cfe4e2b8"
  license "MIT"
  head "https://github.com/Gaurav-Gosain/tuios.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5901a53cf233125c25cb48a947d497e4656951014adc4e326d22e0d09b5c5896"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d3e0b9da8798646340dfc8e662243575ca2f6665d2e66165387fdba990b0574"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "94e62b72fd6e8f3fe792b2c8a0aad803cdebca3f287e691877be061208a6394a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a9657470cc981e86525714f4c810b5587442d37ef6116ba3f8c4fd42b525fdf2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de2b15b891179a77ace17767d82197ec176ee4e5ed5240810beed49380d73ce5"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601} -X main.builtBy=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/tuios"

    generate_completions_from_executable(bin/"tuios", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tuios --version")

    assert_match "git_hub_dark", shell_output("#{bin}/tuios --list-themes")
  end
end
