class Htvend < Formula
  desc "Accelerate your Python functions with cloud GPUs"
  homepage "https://github.com/continusec/htvend"
  url "https://github.com/continusec/htvend/archive/690220a47f03ec1306f64efadaf63145c28ec0ca.tar.gz"
  version "0.0.1"
  sha256 "79890c69f1c16e2b16c4f12633dfc652f6e3c8f5a0480be941903d5a5ac5d0ff"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d21feff68dd2bd803f7b6acd3fecbf713bf99a4aff20280c1a4407cc94c3a57"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac11524bd74e66c4c3ac2742795e76b37e8ea58d3baa3d23131234a3b9d90d9a"
    sha256 cellar: :any_skip_relocation, ventura:       "a91edc93b5a2eebf2c8ecbef8fd06c74638013b0baf6d541cc07533f7c5d138d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66861c9e3b5a92ce82e585203fcd1aedc01ef67749daac5571d0ec2db588af81"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/htvend"
  end

  test do
    output = shell_output("#{bin}/htvend build -- curl https://www.google.com 2>&1")
    assert_match "Fetching URL: https://www.google.com/", output
    assert_path_exists testpath/"assets.json"
  end
end
