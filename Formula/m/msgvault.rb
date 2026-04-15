class Msgvault < Formula
  desc "Offline email archive with fast search and analytics"
  homepage "https://msgvault.io"
  url "https://github.com/wesm/msgvault/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "0d4007d046b754c8b80975077bbed48d0aa214ac555b3e1ac7de7679560d8d12"
  license "MIT"
  head "https://github.com/wesm/msgvault.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b6e36f882252a046c519122a78492caec439dd995204f5d51624a5df3d9ccbe4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "adab1e4a162fcf27f9af673404d3a361acd574e9e4f6aa2d3d59916704a56049"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e51d1a5518473c6e65528343bdda8d497f16dd829bcf7b9c54b08054a89faeea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ccc03e67ebb6deb5c2a1569d24c37a285edad3983ed64df8a21f39cae7e45db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19787a3c173dca438d99211c340ace2d4caba6afb728853dcc082f6a43046fca"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/wesm/msgvault/cmd/msgvault/cmd.Version=#{version}
      -X github.com/wesm/msgvault/cmd/msgvault/cmd.Commit=homebrew
      -X github.com/wesm/msgvault/cmd/msgvault/cmd.BuildDate=#{time.iso8601}
    ]

    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?
    system "go", "build", *std_go_args(ldflags:), "-tags", "fts5", "./cmd/msgvault"

    ENV["MSGVAULT_HOME"] = buildpath/".msgvault"
    generate_completions_from_executable(bin/"msgvault", "completion")
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
