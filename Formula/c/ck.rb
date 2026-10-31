class Ck < Formula
  desc "Local semantic and hybrid BM25 grep for code and text"
  homepage "https://github.com/BeaconBay/ck"
  url "https://github.com/BeaconBay/ck/archive/refs/tags/0.8.1.tar.gz"
  sha256 "69678a5c6e619693ec0fa1743acb42e1ec2b3365487cf918c800ed2f6b2cac2a"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/BeaconBay/ck.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eec9b2f830757fb22b17bbf6906bc01f1b08ba133925d23833d07904f6a083ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4719d81142ad6ee0a941a60dc5d1b5065c0ade452e074a5f96d12aa44c60e9d"
    sha256 cellar: :any,                 arm64_linux:   "216f9d54a1fe52ccdb7b4c72f3d6e609992f14111e432a36f8fc2a0cc4dd8a25"
    sha256 cellar: :any,                 x86_64_linux:  "3e8845872d6bea4ab0c79c245c0a15f66cdd4ef6eeda1e8d913a4ac9e7b5e98f"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "onnxruntime"
  depends_on "openssl@3"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    # Link the packaged native library rather than downloading an ONNX Runtime binary.
    ENV["ORT_LIB_LOCATION"] = formula_opt_lib("onnxruntime")
    ENV["ORT_PREFER_DYNAMIC_LINK"] = "1"
    ENV["ORT_SKIP_DOWNLOAD"] = "1"
    ENV.append "RUSTFLAGS", "-C link-arg=-Wl,-rpath,#{formula_opt_lib("onnxruntime")}"
    system "cargo", "install", *std_cargo_args(path: "ck-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ck --version")

    (testpath/"example.txt").write "first line\nhomebrew-semantic-fixture\nlast line\n"
    output = shell_output("#{bin}/ck -n homebrew-semantic-fixture example.txt")
    assert_match "2:homebrew-semantic-fixture", output
  end
end
