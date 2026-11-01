class SpdxValidate < Formula
  desc "Validates SPDX license expressions"
  homepage "https://github.com/github/go-spdx"
  url "https://github.com/github/go-spdx/archive/refs/tags/v2.8.0.tar.gz"
  sha256 "6115fbe477dfc67cd9ccea22706d3a537112f6bc923f2c07385046d29f5f76e7"
  license "MIT"
  head "https://github.com/github/go-spdx.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "330aec4308eabe2ead6f0434e413d0a0ec5b673b9447d44ccca726b7df8459f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "330aec4308eabe2ead6f0434e413d0a0ec5b673b9447d44ccca726b7df8459f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eac69300750b433f60ea54d43f0aedf047f5bdd0c0394540072cc19ef13eb9f8"
    sha256 cellar: :any,                 x86_64_linux:  "e4c95a3120bf1fe71cde7bb179c7ac6e3ae2e53c7f37e8865cc3bc75058bf78e"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/spdx-validate"

    generate_completions_from_executable bin/"spdx-validate", shell_parameter_format: :cobra
  end

  test do
    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.

    pipe_output(bin/"spdx-validate", "MIT\nApache-2.0 WITH LLVM-exception\n", 0)

    (testpath/"licenses.txt").write <<~EOS
      MIT
      GPL-2.0-or-later WITH Classpath-exception-2.0
      NOT-A-LICENSE
    EOS
    assert_equal <<~EOS, shell_output("#{bin}/spdx-validate --file=licenses.txt 2>&1", 1)
      line 3: invalid SPDX expression: "NOT-A-LICENSE"
      1 of 3 expressions failed validation
    EOS
  end
end
