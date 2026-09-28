class Await < Formula
  desc "Small binary that runs a list of commands in parallel and awaits termination"
  homepage "https://github.com/slavaGanzin/await"
  url "https://github.com/slavaGanzin/await/archive/refs/tags/2.11.0.tar.gz"
  sha256 "2333b49c56cbea5d033162a81ca7bc1aca9436500f1d32740c57901b1ce9a617"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ca32e16f8bc21602a2f400f0863eec31a5e5f954387d65e64c36f2f8e48680c0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d991c3ffac54d7fe701d6455663abecf93388d85282340220e7f20bc85da00bb"
    sha256 cellar: :any,                 arm64_linux:   "97721c1d04c6adb09b4326665f1afa57d2348e879613cbd1aa587c6bb0da5a51"
    sha256 cellar: :any,                 x86_64_linux:  "6252292c60c845123c9c102500fb3cd4bd7a8236cc92d44577f8cee00dbf201a"
  end

  deny_network_access!

  def install
    system ENV.cc, "await.c", "-o", "await", "-lpthread"
    bin.install "await"

    bash_completion.install "autocompletions/await.bash" => "await"
    zsh_completion.install "autocompletions/await.zsh" => "_await"
    fish_completion.install "autocompletions/await.fish"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/await --version")

    (testpath/"test_script.sh").write <<~SHELL
      #!/bin/bash
      echo "Test script running" > "#{testpath}/output.txt"
    SHELL
    chmod 0755, testpath/"test_script.sh"

    system bin/"await", "./test_script.sh"
    assert_path_exists testpath/"output.txt"
    assert_match "Test script running", (testpath/"output.txt").read
  end
end
