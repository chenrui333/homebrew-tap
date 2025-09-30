class Nino < Formula
  desc "Terminal-based text editor inspired by kilo"
  homepage "https://evanlin96069.github.io/nino-editor/"
  url "https://github.com/evanlin96069/nino/archive/c2098041b9839dd793c9c75ac1d4c914f7875510.tar.gz"
  version "0.0.5"
  sha256 "151167c8716c25aa1280b845e34a1f4dc3e7631fda1faa110622688592214370"
  license "BSD-2-Clause"
  head "https://github.com/evanlin96069/nino.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de9aa301536678f629bccba6d853d9ed1fc6a305aad45945bf7733d7ac59953a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f9b9327b424ddbd9244a702c3266bd9ab0cb5eeb9d9856a0974dfd976689693"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06403802565cdd70a4d8bc87ec142247ee09f684f86aaa03b9ba2c859c2ce6bb"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"nino", testpath, [:out, :err] => output_log.to_s
      sleep 1
      assert_match "src/terminal.c: 419: getWindowSize", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
