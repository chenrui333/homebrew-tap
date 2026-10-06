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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "81a96a7aa34f7c0a0932a88976724164fde9aa9a9a18a123862b2d53093907d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1005af3b2d041b14a1139f9ef40d61403bf6b02c89a16ab7975d393144b11064"
    sha256 cellar: :any,                 arm64_linux:   "6d5309e88d3c5e115c65b65b9efbbd7f089d7ed1dbfd1a45337d4de3221e02a2"
    sha256 cellar: :any,                 x86_64_linux:  "3e389a4926ac68c8da98c4d9bbb65e3d679f4aead06946c6ffb5c055d6283660"
  end

  depends_on "cmake" => :build

  deny_network_access!

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
