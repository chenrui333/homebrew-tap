class Msgvault < Formula
  desc "Offline email archive with fast search and analytics"
  homepage "https://msgvault.io"
  url "https://github.com/wesm/msgvault/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "223a33dc0c6030c96eb1f7088ed78dc07be617e4cfca794ed89c91010a63e10f"
  license "MIT"
  head "https://github.com/wesm/msgvault.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1dc6b68dac921230f098e6f92566eef8bc12b8200d11f0c250b6a099f35cbd91"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "89d5786561fc10db7eb14c3d3163564d26e8ea36f4612789e06fa3537a3adfd2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f1039375ad0d409962bfb4ee9e47c7c3a2ed0be01973c921667c5f2219af1503"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aab2b086c50f8bdea06f21dfc6fcc63b42689ab89d19a3275bee9e45f6a0a5d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56c5f173393d43b3d7aad3219209654ad79ed5725d1b8a42647a59dc02ce34b3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/wesm/msgvault/cmd/msgvault/cmd.Version=#{version}
      -X github.com/wesm/msgvault/cmd/msgvault/cmd.Commit=homebrew
      -X github.com/wesm/msgvault/cmd/msgvault/cmd.BuildDate=#{time.iso8601}
    ]

    ENV["CGO_ENABLED"] = "1"
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
