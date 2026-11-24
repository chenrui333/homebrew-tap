class Swamp < Formula
  desc "Deterministic automation framework for AI agents"
  homepage "https://swamp-club.com"
  url "https://git.swamp-club.com/swamp-club/swamp.git",
      tag:      "v20261123.231152.0-sha.50eb628e",
      revision: "50eb628e3bc164a65ef237ccb3b32a27f839407f"
  version "20261123.231152.0-sha.50eb628e"
  # Upstream also grants the additional permissions in COPYING-EXCEPTION.
  license "AGPL-3.0-only"
  head "https://git.swamp-club.com/swamp-club/swamp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "1078cee684206d2d97920ed75c29ea3f1adb2c28a628284b49187c5b3e51b609"
    sha256 cellar: :any,                 arm64_tahoe:   "ee5d70cdb9d38348082d54788e70d506109acb3ab338033571d707706057cd95"
    sha256 cellar: :any,                 arm64_sequoia: "87220e2fdc34a5f2e712891ab22ac53a5131939e2d3251c26b5441513054ba50"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5004f2d8b3d124da9847f1fbc46e53ee895c7535ea4c91750bc16e25bdd2a34f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f31eaa667aa3ba947309efd57deb8049a3ac66213fb598080f34898e43271205"
  end

  depends_on "node" => :build
  depends_on "deno"

  deny_network_access!

  def fetch
    # Keep source-mode version metadata in sync with the release tag after autobumps.
    git_sha = version.to_s.split("-sha.").last
    inreplace "src/infrastructure/runtime/build_info.ts", /^export const VERSION = .*;$/,
              "export const VERSION = \"#{version}\";"
    inreplace "src/infrastructure/runtime/build_info.ts", /^export const GIT_SHA = .*;$/,
              "export const GIT_SHA = \"#{git_sha}\";"
    ENV["DENO_DIR"] = buildpath/"deno-cache"
    system "deno", "cache", "--frozen", "main.ts"
    cd "packages/dashboard" do
      system "npm", "ci", "--ignore-scripts"
    end
    # Match release compilation's check on the stamped, frozen source entrypoint.
    system "deno", "check", "--frozen", "main.ts"
  end

  def install
    cd "packages/dashboard" do
      system "npm", "run", "build"
      rm_r "node_modules"
    end
    # Deno needs optional package metadata; only glibc-native modules can run here.
    rm Dir["deno-cache/npm/registry.npmjs.org/**/*-musl/**/*.node"] if OS.linux?
    pkgshare.install "main.ts", "deno.json", "deno.lock", "src", "packages", "deno-cache",
                     "extensions", "COPYING", "COPYING-EXCEPTION", "COPYRIGHT", "LICENSE"
    (pkgshare/".claude").install ".claude/skills"
    # Source mode uses Deno.execPath() for extension workers; no downloaded denort or embedded runtime.
    (bin/"swamp").write <<~SH
      #!/bin/bash
      set -e
      cache="${XDG_CACHE_HOME:-$HOME/.cache}/swamp/#{version}"
      if [[ ! -d "$cache" ]]; then
        mkdir -p "${cache%/*}"
        cp -R "#{pkgshare}/deno-cache" "$cache"
      fi
      export DENO_DIR="$cache"
      exec "#{formula_opt_bin("deno")}/deno" run --cached-only --frozen --unstable-bundle \
        --allow-read --allow-write --allow-env --allow-run --allow-sys --allow-net --allow-ffi \
        --config "#{pkgshare}/deno.json" "#{pkgshare}/main.ts" "$@"
    SH
    chmod 0755, bin/"swamp"
    generate_completions_from_executable(bin/"swamp", "completions")
  end

  def caveats
    <<~EOS
      Swamp requires a swamp-club.com account for normal commands. Run:
        swamp auth login
      Initialize your service repository in #{var}/swamp before starting brew services.
    EOS
  end

  service do
    run [opt_bin/"swamp", "serve", "--repo-dir", var/"swamp", "--host", "127.0.0.1"]
    working_dir var/"swamp"
    log_path var/"log/swamp.log"
    error_log_path var/"log/swamp.log"
  end

  test do
    ENV["SWAMP_NO_TELEMETRY"] = "1"
    ENV.delete "SWAMP_API_KEY"
    ENV.delete "SWAMP_API_KEY_FILE"
    ENV.delete "SWAMP_SIGNIN_TOKEN"
    assert_match version.to_s, shell_output("#{bin}/swamp --version")
    output = shell_output("#{bin}/swamp model list 2>&1", 1)
    assert_match "swamp requires a swamp-club.com account to run", output
  end
end
