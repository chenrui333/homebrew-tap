class Sgpt < Formula
  desc "CLI tool to query OpenAI and generate shell commands and code"
  homepage "https://github.com/tbckr/sgpt"
  url "https://github.com/tbckr/sgpt/archive/refs/tags/v2.21.1.tar.gz"
  sha256 "77f89970a6c98a4a821a2243c2139f01500a824b81aa002e9138fbf938ea9238"
  license "Apache-2.0"
  head "https://github.com/tbckr/sgpt.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d49f9d99a21ed03557716da5ba6a98d2992c382a5e22f4892ce1922819fbf746"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d49f9d99a21ed03557716da5ba6a98d2992c382a5e22f4892ce1922819fbf746"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d49f9d99a21ed03557716da5ba6a98d2992c382a5e22f4892ce1922819fbf746"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e3065b66cd68e0521dd2236cdf2176587e9435dd8f03f04dee1457a57743159"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74ae34c4b01f70d0c1fc6b209d6f54ef0e2d4447110f80e3734dd36d2ccb3b00"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/tbckr/sgpt/internal/buildinfo.version=#{version}
      -X github.com/tbckr/sgpt/internal/buildinfo.commit=#{tap.user}
      -X github.com/tbckr/sgpt/internal/buildinfo.commitDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/sgpt"

    generate_completions_from_executable(bin/"sgpt", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sgpt version")

    ENV["OPENAI_API_KEY"] = "fake"

    assert_match "configuration is valid", shell_output("#{bin}/sgpt check")
  end
end
