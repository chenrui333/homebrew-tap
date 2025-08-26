class Await < Formula
  desc "Small binary that runs a list of commands in parallel and awaits termination"
  homepage "https://github.com/slavaGanzin/await"
  url "https://github.com/slavaGanzin/await/archive/refs/tags/2.1.0.tar.gz"
  sha256 "167ec2e23edc6213abb192601611d60c87dd4d3f3796a9d3d560fe214c1f2807"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24adb3cd0e04c6430321dfee9d0106576c1a200c5ac124a9fc2083b2e33253ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0141205d150d04fde1fc5259088b0d3b10b3cd13983d6c379de61d846f8cf139"
    sha256 cellar: :any_skip_relocation, ventura:       "1760621ccaa6447b7c6e56873280132c65bbf9c2611f97b4024532e68bd9096f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8b88d3286f11595f383415c3082cbb3e986d863187be62d04998c40da61edae"
  end

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
