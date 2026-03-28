class Orla < Formula
  desc "High-performance execution engine for open-source agents"
  homepage "https://github.com/dorcha-inc/orla"
  url "https://github.com/dorcha-inc/orla/archive/refs/tags/v1.2.11.tar.gz"
  sha256 "d8fdabf5de981ba4441cd1c18b34291ba90ab24a93770aba42537ced868d8392"
  license "MIT"
  head "https://github.com/dorcha-inc/orla.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3f12a07fa60a4f9c28ff31059a99b6f45ff546f292028c326e8a572c6671ecf0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ab89503e074971ac19168ea98805fb81d1794891a7007a7e1fb2234654fe74c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b202824c445b8e34bcf1684aa2f0320c8d013c0b718b723f9e50c7c463b0eb2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fbc49d3c420be56267b6ad0390e68833d2d3240aea613382ac7c13f73ce854cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee5c20bf4d667e1abaec9e02613350dfb54d5128cfb075c801f73f8b94939945"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/orla"

    generate_completions_from_executable(bin/"orla", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/orla --version")
    assert_match "Start orla's agent engine as a service", shell_output("#{bin}/orla serve --help")
  end
end
