class Await < Formula
  desc "Small binary that runs a list of commands in parallel and awaits termination"
  homepage "https://github.com/slavaGanzin/await"
  url "https://github.com/slavaGanzin/await/archive/refs/tags/1.0.8.tar.gz"
  sha256 "727d4a96ee5d45a80dd2645dc0b13ee3facac709c3e778118259a73a88ee8243"
  license "MIT"

  def install
    # patch version
    inreplace "await.c", "1.0.9", version.to_s

    system ENV.cc, "await.c", "-o", "await", "-lpthread"
    bin.install "await"
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
