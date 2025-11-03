class Permify < Formula
  desc "Open-source authorization service & policy engine based on Google Zanzibar"
  homepage "https://github.com/Permify/permify"
  url "https://github.com/Permify/permify/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "4d524431c9d8eb9c79f611589e0f8ed11c4a27f234a6914f2ea2f10e49efdc26"
  license "AGPL-3.0-only"
  head "https://github.com/Permify/permify.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9486b09f80b5a7f0b7fd2a82837145ca34df6d9540e9a948cdebf9a98cc2b00b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f53fd2daba50136e72e96c0679d3813a3541e6f66987ab973618dba44fc52b4c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6563adb77acf9ea9901bca26a27a0a06ee999364df467587d0ebe7e3d7c7f59d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "10afd688888904155beb6a1c4b80815bbc34366c19896c1f111c1c4c064ad3f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "923da33fd2c1cbefb5361ccc36fa1be7373b7d4b02d551fcc8f74c8da832cb0a"
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
