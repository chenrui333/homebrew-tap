class Await < Formula
  desc "Small binary that runs a list of commands in parallel and awaits termination"
  homepage "https://github.com/slavaGanzin/await"
  url "https://github.com/slavaGanzin/await/archive/refs/tags/2.3.0.tar.gz"
  sha256 "6fd1878e1a84cd89bc80f885dbcce48651a5c4682c0512f32c2d471e71cf8d80"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "89ec5a8b068d063a032d5e9eba0c693cf5f5be71d810f75d48c369bb3bc905b4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "413f0d4c1e16c5c6dcde5a8e879350f8f4ce5245d668df0e58d6884ff60bac32"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "083d730f7840215f0d4b0cdb166e713e51d8232392d1f3f7c35521d659a66f9c"
    sha256 cellar: :any_skip_relocation, sequoia:       "ee59724890f4436d5d459255b63e14744e2f6da05fa2cd8dfe9134604f1604eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b9728e0675156d2b6abe30d1739dd7f3c5b41ec034c5598f557facc97375c24c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f49b4b3711b359c6151b9980d4cc73d6613560ddfdef6b6fadc11e7b2e6f2f4f"
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
