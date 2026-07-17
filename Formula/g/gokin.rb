class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.100.100.tar.gz"
  sha256 "a0de4e01956f8c965082f87dd7b2bbe283d2ab64d8f5117f00141ad078123466"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "037980e04c9c577166d0fba562e4725d8ed10d17d6e8e2f0c3abe8ba25ffa1ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "037980e04c9c577166d0fba562e4725d8ed10d17d6e8e2f0c3abe8ba25ffa1ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "037980e04c9c577166d0fba562e4725d8ed10d17d6e8e2f0c3abe8ba25ffa1ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "baaeecc51cb4aabb4a1e198388c4fb34e02243b56f9e8bbab3d20e3516af1874"
    sha256 cellar: :any,                 x86_64_linux:  "21387e1fe48f3c129b2f8e6571ccb79fcf8957b466b488a428ea2da77ecdaff9"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/gokin"

    generate_completions_from_executable(bin/"gokin", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gokin version")
    output = shell_output("#{bin}/gokin not-a-real-command 2>&1", 1)
    assert_match "unknown command", output
  end
end
