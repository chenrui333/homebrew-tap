class Curlmin < Formula
  desc "Remove unnecessary headers, cookies, and query parameters from a curl command"
  homepage "https://github.com/noperator/curlmin"
  url "https://github.com/noperator/curlmin/archive/5b5e4eeeff42df354c822c3147206993638323d6.tar.gz"
  version "0.0.1"
  sha256 "ede81edd109f7ab2c4a4811f1187b740cb756bc796cfcfe7c3d32527c23a8191"
  license "MIT"
  head "https://github.com/noperator/curlmin.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/curlmin"

    generate_completions_from_executable bin/"curlmin", shell_parameter_format: :cobra
  end

  test do
    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.
    output = shell_output("#{bin}/curlmin --file #{testpath}/missing.sh 2>&1", 1)
    assert_match "Error reading from file", output
    assert_match "missing.sh", output
  end
end
