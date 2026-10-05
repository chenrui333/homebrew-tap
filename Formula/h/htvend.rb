class Htvend < Formula
  desc "Accelerate your Python functions with cloud GPUs"
  homepage "https://github.com/continusec/htvend"
  url "https://github.com/continusec/htvend/archive/690220a47f03ec1306f64efadaf63145c28ec0ca.tar.gz"
  version "0.0.1"
  sha256 "79890c69f1c16e2b16c4f12633dfc652f6e3c8f5a0480be941903d5a5ac5d0ff"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6097e10d51a6b2e9c94fa547b389339c5cd5479257c5bd28e36c09b29d806f46"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6097e10d51a6b2e9c94fa547b389339c5cd5479257c5bd28e36c09b29d806f46"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e0a5a3290c77874a52d051c19e3b2203ca89f59235083805cb92acefcd99b202"
    sha256 cellar: :any,                 x86_64_linux:  "376205d921b807bd5ef7674233c2a923ce641364082906be74126ce5dcc12853"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/htvend"
  end

  test do
    blob = "hello"
    sha = Digest::SHA256.hexdigest(blob)
    (testpath/"cache"/sha).write blob
    (testpath/"assets.json").write <<~JSON
      {"https://example.com/hello.txt": {"Sha256": "#{sha}", "Size": #{blob.size}}}
    JSON

    output = shell_output("#{bin}/htvend export --blobs-dir cache -o out 2>&1")
    assert_match "Verifying https://example.com/hello.txt", output
    assert_equal blob, (testpath/"out"/sha).read
  end
end
