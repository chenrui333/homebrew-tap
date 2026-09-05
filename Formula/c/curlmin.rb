class Curlmin < Formula
  desc "Remove unnecessary headers, cookies, and query parameters from a curl command"
  homepage "https://github.com/noperator/curlmin"
  url "https://github.com/noperator/curlmin/archive/5b5e4eeeff42df354c822c3147206993638323d6.tar.gz"
  version "0.0.1"
  sha256 "ede81edd109f7ab2c4a4811f1187b740cb756bc796cfcfe7c3d32527c23a8191"
  license "MIT"
  head "https://github.com/noperator/curlmin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "322a12be3a01c42c2b4839c329a5232b4873767fa47b9ecdfde905139a8819c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "322a12be3a01c42c2b4839c329a5232b4873767fa47b9ecdfde905139a8819c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "322a12be3a01c42c2b4839c329a5232b4873767fa47b9ecdfde905139a8819c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7976a0344d2704d7c619af9b5947d568bc2be5f899f7d169b16a7fccdb70e39d"
    sha256 cellar: :any,                 x86_64_linux:  "e8811cad4d6ce10240a3003b2ff0902d90c97a0a1c4f50f6749200365f117778"
  end

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
