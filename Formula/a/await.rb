class Await < Formula
  desc "Small binary that runs a list of commands in parallel and awaits termination"
  homepage "https://github.com/slavaGanzin/await"
  url "https://github.com/slavaGanzin/await/archive/refs/tags/2.4.0.tar.gz"
  sha256 "3abecf4f70382970476102ab4ef9601cf30564cc3a0f8385228b791f3e515960"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7c1af7f9a8341aa74241bba5d90625f3eacfc6aa195f708b14b039657b827ecc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba9d24fbce11fd328c530a8a5f76a194f59373b96ee8f1d5b14eddb4add47384"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b20c60d98c1947298d7671e505d0513a46d0a57b157e0cfdcfea867c80651831"
    sha256 cellar: :any_skip_relocation, sequoia:       "064656380b20fa45802ae581b18a2c50bb0c6a815db4912b28ef6e5f979f2d38"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "14d0e9a0c2a7c1d6110cafb9ae9b55a6f8ce5399882ac90322420037804e05fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d92ce75e182fdc2b0c63feb9e954f184bcb492df52812e44daf6ad9030cffb6"
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
