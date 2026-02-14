class Yr < Formula
  desc "Get the weather delivered to your command-line"
  homepage "https://git.sr.ht/~timharek/yr"
  url "https://git.sr.ht/~timharek/yr/archive/v1.1.0.tar.gz"
  sha256 "cf7b92d980f74278623306f4b715acfd69c629266849f61999570005b3f2cc7e"
  license "GPL-3.0-only"
  head "https://git.sr.ht/~timharek/yr", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5f481c550bc92bd80fc243122c9ad5f8ff9221c00c10a9f6403ce33b6892a346"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f481c550bc92bd80fc243122c9ad5f8ff9221c00c10a9f6403ce33b6892a346"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f481c550bc92bd80fc243122c9ad5f8ff9221c00c10a9f6403ce33b6892a346"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b04b1bd515f95fb18b93a078d5172c7817b25623e1da96565befbbc10f81857"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18d37bafa46cf44beaa7cd617af47e5213ecd07d9f0fa0c35d77ec15adeeb0b4"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}"), "./cmd/yr"

    generate_completions_from_executable(bin/"yr", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yr --version")

    assert_match "New York", shell_output("#{bin}/yr now nyc")
  end
end
