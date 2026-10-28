class UnusedDeps < Formula
  desc "Determine any unused dependencies in java_library rules"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://github.com/bazelbuild/buildtools/archive/refs/tags/v10.2.0.tar.gz"
  sha256 "5af90068e9e8812abdc455ad04cc474470bccc8bbabc8b571e3f58a66799680f"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/buildtools.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4279dd5e8d1705a15b5ea252b14a84e3b28a20b689208836d145c349706cba13"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4279dd5e8d1705a15b5ea252b14a84e3b28a20b689208836d145c349706cba13"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bcc5e9ba7a2b95700cf1e07a75c670501d9bc1b01f1344feb76f09b9a28b0da4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ba456edd238a8f900092cd82a9d873ebdfded6cf27e6364db9a6a57708a71bb"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.buildVersion=#{version}", output: bin/"unused_deps"), "./unused_deps"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/unused_deps --version")

    (testpath/"bin").mkpath
    output = with_env(PATH: (testpath/"bin").to_s) do
      shell_output("#{bin}/unused_deps 2>&1", 2)
    end
    assert_match "executable file not found", output
  end
end
