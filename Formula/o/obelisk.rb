class Obelisk < Formula
  desc "Durable and deterministic workflow engine"
  homepage "https://github.com/obeli-sk/obelisk"
  url "https://github.com/obeli-sk/obelisk/archive/refs/tags/v0.42.0.tar.gz"
  sha256 "84b5f6d7407712a7e6c98c2b5dec3a025a31fadf7e58227b93e4fa6feef385d5"
  license "AGPL-3.0-only"
  head "https://github.com/obeli-sk/obelisk.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "648c782ef45e69da900e097d9097a512dd73b00502c2b74ea012f2d0bf8b5164"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d4bd4d88783a29e377d40ab6e898109b9a2b3bb81c6238bbd36103bb94b0227"
    sha256 cellar: :any,                 arm64_linux:   "04acc3ec49c267ed8bf0779c04a878da15fd34cd467ba227c285405955ba8ee7"
    sha256 cellar: :any,                 x86_64_linux:  "b5763555e31bbe6a2f6a1c794f0b0641438bdd6aa89b359165b9a03bc0e35b18"
  end

  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build

  # Prebuilt V8 for the locked `v8` crate (150.4.0 with `simdutf`); its build.rs downloads this otherwise.
  resource "rusty_v8" do
    on_macos do
      on_arm do
        url "https://github.com/denoland/rusty_v8/releases/download/v150.4.0/librusty_v8_simdutf_release_aarch64-apple-darwin.a.gz"
        sha256 "5aeffd8d5a0c1b79ac1d70af83d5b19099655fd9c645a794dc43f101f779838c"
      end
      on_intel do
        url "https://github.com/denoland/rusty_v8/releases/download/v150.4.0/librusty_v8_simdutf_release_x86_64-apple-darwin.a.gz"
        sha256 "a750271fec6b211457ed0a5cf7d2eab1924b265621a82da86ab959d6ff0823e4"
      end
    end
    on_linux do
      on_arm do
        url "https://github.com/denoland/rusty_v8/releases/download/v150.4.0/librusty_v8_simdutf_release_aarch64-unknown-linux-gnu.a.gz"
        sha256 "539e283815a396a5796f32858b42e517b858ebaaeaaad05d03290ee8c864a527"
      end
      on_intel do
        url "https://github.com/denoland/rusty_v8/releases/download/v150.4.0/librusty_v8_simdutf_release_x86_64-unknown-linux-gnu.a.gz"
        sha256 "f48762ca10d1f1fc605a441c5ae430ec8ce1e9e80f14d78fbc42cb878c30b476"
      end
    end
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args

    # The default `embed-webui` feature pulls this pinned OCI layer (crates/embedded-assets/webui-version.txt)
    # in build.rs; prefetch it for `OBELISK_EMBED_ASSETS_DIR`.
    repo = "getobelisk/webui"
    layer = "32287ac00295fcf686ae917907f3613f37a2e6be080854aa7639ebf0c392478d"
    token_url = "https://auth.docker.io/token?service=registry.docker.io&scope=repository:#{repo}:pull"
    token = JSON.parse(Utils.safe_popen_read("curl", "-fsSL", token_url)).fetch("token")
    webui = buildpath/"embed-assets/webui.wasm"
    webui.dirname.mkpath
    system "curl", "-fsSL", "-H", "Authorization: Bearer #{token}", "-o", webui,
           "https://registry-1.docker.io/v2/#{repo}/blobs/sha256:#{layer}"
    odie "webui.wasm checksum mismatch" if webui.sha256 != layer
  end

  def install
    ENV["RUSTY_V8_ARCHIVE"] = resource("rusty_v8").cached_download
    ENV["OBELISK_EMBED_ASSETS_DIR"] = buildpath/"embed-assets"
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/obelisk --version")
    output = shell_output("#{bin}/obelisk --not-a-real-option 2>&1", 2)
    assert_match "not-a-real-option", output
  end
end
