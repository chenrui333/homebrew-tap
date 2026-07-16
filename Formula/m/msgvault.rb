class Msgvault < Formula
  desc "Offline email archive with fast search and analytics"
  homepage "https://msgvault.io"
  url "https://github.com/wesm/msgvault/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "6c3539d69de1b1856df84fd6bee782418cf4dd9c0e0140765bc0d30231360740"
  license "MIT"
  head "https://github.com/wesm/msgvault.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3d77cde736b190a40087b73566b7e41d5ead18c5926ddd7575a744ca1d0a2a09"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f1ec18b03a5efabea46fb9c27b83357c323ae8452eba171afa77a0d77235c6a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "adc9d26b1b7b985c1f0bba0dc830610af1e34f696bf071615d3e7a7034b27d89"
    sha256 cellar: :any,                 arm64_linux:   "bbe4c926d9ebaa078ece7709ab40aad0b6e490ac2fdee83abe9b9839aa4a3a13"
    sha256 cellar: :any,                 x86_64_linux:  "8e6915c2b059010413c4f3444ce9631c1a4b957ef264e7dfd7e5727df25b6db3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X go.kenn.io/msgvault/cmd/msgvault/cmd.Version=#{version}
      -X go.kenn.io/msgvault/cmd/msgvault/cmd.Commit=homebrew
      -X go.kenn.io/msgvault/cmd/msgvault/cmd.BuildDate=#{time.iso8601}
    ]

    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?
    system "go", "build", *std_go_args(ldflags:), "-tags", "fts5", "./cmd/msgvault"

    ENV["MSGVAULT_HOME"] = buildpath/".msgvault"
    generate_completions_from_executable(bin/"msgvault", shell_parameter_format: :cobra)
  end

  test do
    ENV["MSGVAULT_HOME"] = testpath.to_s

    assert_match version.to_s, shell_output("#{bin}/msgvault version")

    init_output = shell_output("#{bin}/msgvault init-db")
    assert_match "Database:", init_output
    assert_match "Messages:    0", init_output

    stats_output = shell_output("#{bin}/msgvault stats --local")
    assert_match "Accounts:    0", stats_output
  end
end
