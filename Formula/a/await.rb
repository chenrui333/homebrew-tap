class Await < Formula
  desc "Small binary that runs a list of commands in parallel and awaits termination"
  homepage "https://github.com/slavaGanzin/await"
  url "https://github.com/slavaGanzin/await/archive/refs/tags/1.0.8.tar.gz"
  sha256 "727d4a96ee5d45a80dd2645dc0b13ee3facac709c3e778118259a73a88ee8243"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "344eaa819cd80b38efb874962a7c2fef4afee5e4e942e9408aadb32eb3f962cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "00e90c8fe612176435217a4842bffa01a8dd470e300b90b159af185fa7e47915"
    sha256 cellar: :any_skip_relocation, ventura:       "be686dcefbe3659551fa5a321a154ed1c29d2030cb6d5975a8a8bbafb306c77e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45f6fc1691f05b5c906c17c189f2ab60e59792a2e84e676a1022341ab33cd4e1"
  end

  def install
    # patch version
    inreplace "await.c", "1.0.9", version.to_s

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
