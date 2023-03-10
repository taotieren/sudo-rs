FROM rust:1.67
RUN apt-get update && \
    apt-get install -y --no-install-recommends libclang-dev libpam0g-dev
# cache the crates.io index in the image for faster local testing
RUN cargo search sudo
WORKDIR /usr/src/sudo
COPY . .
RUN cargo build --locked -p sudo
# set setuid
RUN install --mode 4755 target/debug/sudo /usr/bin/sudo
# remove build dependencies
RUN apt-get autoremove -y libclang-dev
# HACK sudo-rs is hard-coded to use /etc/sudoers.test
RUN ln -s sudoers /etc/sudoers.test
