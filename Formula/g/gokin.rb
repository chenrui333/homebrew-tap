class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.54.0.tar.gz"
  sha256 "77b48796ebae92c2be1fbd914ca6b676ae6510ac6288c99a384c480cd449b299"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "050fa7e5dac610f6f56b68005dea1ffac941192dc358aa9e824faee6549c2ac1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "050fa7e5dac610f6f56b68005dea1ffac941192dc358aa9e824faee6549c2ac1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "050fa7e5dac610f6f56b68005dea1ffac941192dc358aa9e824faee6549c2ac1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "51da0cc21be7caa2a4fe34c7cef849bb9d45fa587d212d61ab8827e91b80a004"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76b4937f1b4e9fe48f40ae513101c270ba99d788cd3a70d670b95abba1973ff4"
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
