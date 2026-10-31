class SpdxValidate < Formula
  desc "Validates SPDX license expressions"
  homepage "https://github.com/github/go-spdx"
  url "https://github.com/github/go-spdx/archive/refs/tags/v2.8.0.tar.gz"
  sha256 "6115fbe477dfc67cd9ccea22706d3a537112f6bc923f2c07385046d29f5f76e7"
  license "MIT"
  head "https://github.com/github/go-spdx.git", branch: "main"

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
