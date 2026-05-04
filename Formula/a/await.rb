class Await < Formula
  desc "Small binary that runs a list of commands in parallel and awaits termination"
  homepage "https://github.com/slavaGanzin/await"
  url "https://github.com/slavaGanzin/await/archive/refs/tags/2.6.0.tar.gz"
  sha256 "19695cac1f98d9a5b4d83594f200acae961dca6dafc3a414c20abf81c3be49da"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "47d20cde0ce1779e428190e8262cfc4431d0535a0981fa479f60e4adc7f4e3dd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f0e3f3dcb11ffa884e391cc20e06f754fd741a6bf35231d8637ef9a9d468b530"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f8dd4db0236c46c512a6db49b7a4e347646f1d594b53dcf8c0b9c2e60cdf6bf6"
    sha256 cellar: :any_skip_relocation, sequoia:       "d8f04d2a0f85c38dacf416078b0877c24e374b870c06d4bc81b3fd914da120fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3107b42e021fee2abd58dd895f78ab739ff2a8db1735ad6df111711bd96084e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa3bc90f324e3db4111674784e50bb3e7b0bd60dd4df93dd2f4f8ab55782e3f3"
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
