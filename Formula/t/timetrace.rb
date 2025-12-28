class Timetrace < Formula
  desc "CLI for tracking your working time"
  homepage "https://github.com/dominikbraun/timetrace"
  url "https://github.com/dominikbraun/timetrace/archive/refs/tags/v0.14.3.tar.gz"
  sha256 "670ae0b147ddd6a430efb0a727f1612bcc66fffb025855f151760002c63fb847"
  license "Apache-2.0"
  head "https://github.com/dominikbraun/timetrace.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9885d0f8db7548a3dc3f033ce4c30d6ef85b904a4278f27730d0cd76fc7c2fdc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9885d0f8db7548a3dc3f033ce4c30d6ef85b904a4278f27730d0cd76fc7c2fdc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9885d0f8db7548a3dc3f033ce4c30d6ef85b904a4278f27730d0cd76fc7c2fdc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "993d2b745603dfd6709378d1727ce5d1fd534e3dffc7de32ccaca25e324954cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "053802823cdecc0138204022db1a99e430b672e571690c9b163dd64617161d1c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")

    generate_completions_from_executable(bin/"timetrace", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/timetrace --version")

    assert_match "KEY", shell_output("#{bin}/timetrace list projects")
  end
end
