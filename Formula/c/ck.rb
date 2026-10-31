class Ck < Formula
  desc "Local semantic and hybrid BM25 grep for code and text"
  homepage "https://github.com/BeaconBay/ck"
  url "https://github.com/BeaconBay/ck/archive/refs/tags/0.8.1.tar.gz"
  sha256 "69678a5c6e619693ec0fa1743acb42e1ec2b3365487cf918c800ed2f6b2cac2a"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/BeaconBay/ck.git", branch: "main"

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
