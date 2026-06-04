class Msgvault < Formula
  desc "Offline email archive with fast search and analytics"
  homepage "https://msgvault.io"
  url "https://github.com/wesm/msgvault/archive/refs/tags/v0.15.1.tar.gz"
  sha256 "f088aecf74f633ac364a1a321475efdf2c9f739576765ac1f028bc0e96c5331f"
  license "MIT"
  head "https://github.com/wesm/msgvault.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dec70f5bf0992a2f380b0dbcd51a340374d77e9f0469933fe821357b8278edcb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "207324698b4c02591cc861fb37183ef9d3b186ac2270cf22ab6c2f95f8707674"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "925dc76b4c7b98e835022ec519b915c4221d744cae5d590207d6ec4c3daca131"
    sha256 cellar: :any,                 arm64_linux:   "fbc5355b74641dbf084c307826cffc09264f472bf5421071f2d3e00b19829041"
    sha256 cellar: :any,                 x86_64_linux:  "1b1ab9081f740bcb3be020a806beb62b306785d495ec8a5fbf0da112f24d9949"
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
