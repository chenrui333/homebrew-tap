class Nino < Formula
  desc "Terminal-based text editor inspired by kilo"
  homepage "https://evanlin96069.github.io/nino-editor/"
  url "https://github.com/evanlin96069/nino/archive/c2098041b9839dd793c9c75ac1d4c914f7875510.tar.gz"
  version "0.0.5"
  sha256 "151167c8716c25aa1280b845e34a1f4dc3e7631fda1faa110622688592214370"
  license "BSD-2-Clause"
  head "https://github.com/evanlin96069/nino.git", branch: "master"

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    output_log = testpath/"output.log"
    pid = spawn bin/"nino", testpath, [:out, :err] => output_log.to_s
    sleep 1
    assert_match "src/terminal.c: 419: getWindowSize", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
