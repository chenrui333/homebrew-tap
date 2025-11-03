class Permify < Formula
  desc "Open-source authorization service & policy engine based on Google Zanzibar"
  homepage "https://github.com/Permify/permify"
  url "https://github.com/Permify/permify/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "4d524431c9d8eb9c79f611589e0f8ed11c4a27f234a6914f2ea2f10e49efdc26"
  license "AGPL-3.0-only"
  head "https://github.com/Permify/permify.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f13a56bf8f27d0022a3fb10213ed6c5d2e0dbda209f0b94d5f2990520182c84c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b685a0fa0fa68e19abba9467eddeb7b1de8dbd296d014114d167f5acedf5c11b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7d24b1daca27393fad50001552a8863d924a617f8c3f3eaa200e62828c3d7716"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "03ec4c3c946a49bc83a683b0a4c4d31fd9148c4129d131b19d5b337a02db6d74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "507026d95edc3f33e34ae79d0abe9081144f40a44420a410d1f38eb16d5b90bd"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/permify"

    generate_completions_from_executable(bin/"permify", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/permify version")

    (testpath/"schema.yaml").write <<~YAML
      schema: >-
        entity user {}

        entity document {
          relation viewer @user
          action view = viewer
        }
    YAML

    output = shell_output("#{bin}/permify ast #{testpath}/schema.yaml")
    assert_equal "document", JSON.parse(output)["entityDefinitions"]["document"]["name"]
  end
end
