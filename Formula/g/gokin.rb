class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.55.8.tar.gz"
  sha256 "34f569d0861e6f987412a464c35bd321d6422c3daebc0c6df5bde12051ebb8fb"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d4b2e6d91b1c157776b7332eeb7963cd1d8a9effae5b2d1fd0eb0bc2ab93340f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4b2e6d91b1c157776b7332eeb7963cd1d8a9effae5b2d1fd0eb0bc2ab93340f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d4b2e6d91b1c157776b7332eeb7963cd1d8a9effae5b2d1fd0eb0bc2ab93340f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "32a754384034457f778a06d668fb68389f652edfa23b999bedb8a71bc711ca80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "437c351b830a997a8c46b4fe32d3ceddc14b84dfe16cca971513ad7c0329bf3b"
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
