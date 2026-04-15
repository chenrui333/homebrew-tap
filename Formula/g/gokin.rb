class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.60.0.tar.gz"
  sha256 "3d30c0184f83f200127e78c64b897ad1dc838c61f833853dfd6fa82056c95261"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "52c469aec54b9b3c193894b93ee02a436b43cf102f01203faad5c55d1211a98e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52c469aec54b9b3c193894b93ee02a436b43cf102f01203faad5c55d1211a98e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "52c469aec54b9b3c193894b93ee02a436b43cf102f01203faad5c55d1211a98e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7b9acfccb24e4fa2944eaece70381720f4e8bdb4aeb19d81849fad685f5fd8ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a7104fc8c540f1e34d07c8679d30dadb26392f20677f03f0ab8f9e6f577ca65"
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
