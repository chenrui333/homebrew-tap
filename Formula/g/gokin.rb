class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.72.2.tar.gz"
  sha256 "38af0d03ccf36f313adc0f6ff304c4c6c5912dcece1f28f0f6fa19fcac29120a"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1e83af66f934cdaad20b3a6ea9be2be70b8c7eaeeeced387d7e266a7e8f086df"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e83af66f934cdaad20b3a6ea9be2be70b8c7eaeeeced387d7e266a7e8f086df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e83af66f934cdaad20b3a6ea9be2be70b8c7eaeeeced387d7e266a7e8f086df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "17226f97533ee429abb44aafd176c9234b721331fea223767252dcec54e4c45f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "acde2c5c19ee9f2fbbd43878f5cd0109b4e9611854ae4753037c3389d53e3ed9"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/gokin"

    generate_completions_from_executable(bin/"gokin", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gokin version")
    assert_match "Available Commands:", shell_output("#{bin}/gokin --help")
  end
end
