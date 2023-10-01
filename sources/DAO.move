module dao::DAO {
    use sui::transfer::{Self};
    use sui::object::{Self, UID};
    //use sui::tx_context::{Self,TxContext};
    use sui::url::{Self, Url};
    use std::string::{Self,String};
    use std::option::{Self,Option};
    use std::vector;
    use sui::transfer::transfer;
    use sui::tx_context::{sender, TxContext};

        /// Proposal data struct.
    struct Proposal<phantom Token: store, Action: store> has key {
        /// id of the proposal
        id: UID,
        /// creator of the proposal
        proposer: address,
        /// when voting begins.
        start_time: u64,
        /// when voting ends.
        end_time: u64,
        /// count of voters who agree with the proposal
        for_votes: u128,
        /// count of voters who're against the proposal
        against_votes: u128,
        /// executable after this time.
        eta: u64,
        /// after how long, the agreed proposal can be executed.
        action_delay: u64,
        /// how many votes to reach to make the proposal pass.
        quorum_votes: u128,
        /// proposal action.
        action: Action,
    }
     /// emitted when proposal created.
      struct ProposalCreatedEvent has drop, store {
        /// the proposal id.
        proposal_id: u64,
        /// proposer is the user who create the proposal.
        proposer: address,
    }


    /// Proposal state
    const PENDING: u8 = 1;
    const ACTIVE: u8 = 2;
    const DEFEATED: u8 = 3;
    const AGREED: u8 = 4;
    const QUEUED: u8 = 5;
    const EXECUTABLE: u8 = 6;
    const EXTRACTED: u8 = 7;
    /// A handle for an event such that:
    /// 1. Other modules can emit events to this handle.
    /// 2. Storage can use this handle to prove the total number of events that happened in the past.
    struct EventHandle<phantom T: drop + store> has store {
        /// Total number of events emitted to this event stream.
        counter: u64,
        /// A globally unique ID for this event stream.
        guid: vector<u8>,
    }
    // struct DaoGlobalInfo<phantom Token: store> has key {
    //     /// next proposal id.
    //     next_proposal_id: UID,
    //     /// proposal creating event.
    //     proposal_create_event: EventHandle<ProposalCreatedEvent>,
    //     // voting event.
    //     //vote_changed_event: EventHandle<VoteChangedEvent>,
    // }

    /// Configuration of the `Token`'s DAO.
    struct DaoConfig<phantom TokenT: copy + drop + store> has copy, drop, store {
        /// after proposal created, how long use should wait before he can vote (in milliseconds)
        voting_delay: u64,
        /// how long the voting window is (in milliseconds).
        voting_period: u64,
        /// the quorum rate to agree on the proposal.
        /// if 50% votes needed, then the voting_quorum_rate should be 50.
        /// it should between (0, 100].
        voting_quorum_rate: u8,
        /// how long the proposal should wait before it can be executed (in milliseconds).
        min_action_delay: u64,
    }

    spec DaoConfig {
        invariant voting_quorum_rate > 0 && voting_quorum_rate <= 100;
        invariant voting_delay > 0;
        invariant voting_period > 0;
        invariant min_action_delay > 0;
    }
    // struct CurrentTimeMilliseconds has key {
    //     milliseconds: u64,
    // }

    // public fun GENESIS_ADDRESS(): address {
    //     @0x1
    // }
    // public fun now_milliseconds(): u64 acquires CurrentTimeMilliseconds {
    //     return borrow_global<CurrentTimeMilliseconds>(GENESIS_ADDRESS()).milliseconds
    // }
   /// propose a proposal.
    /// `action`: the actual action to execute.
    /// `action_delay`: the delay to execute after the proposal is agreed
    public fun propose<TokenT: copy + drop + store, ActionT: copy + drop + store>(
        signer: &signer,
        action: ActionT,
        action_delay: u64,
        ctx  : &mut TxContext,
    )  {
        // if (action_delay == 0) {
        //     action_delay = min_action_delay<TokenT>();
        // } else {
        //     assert!(action_delay >= min_action_delay<TokenT>(), Errors::invalid_argument(ERR_ACTION_DELAY_TOO_SMALL));
        // };
        //hardcoded values
       // let id = 12356;
        let id = object::new(ctx);
        let proposer = sender(ctx);
        let start_time = 1696199883166;


        let quorum_votes = 10;
        let proposal = Proposal<TokenT, ActionT> {
            id,
            proposer,
            start_time,
            end_time: start_time + 900000,
            for_votes: 0,
            against_votes: 0,
            eta: 0,
            action_delay,
            quorum_votes,
            action: action,
        };
        transfer(proposal, sender(ctx));
        //move_to(signer, proposal);
        // emit event
        // let gov_info = borrow_global_mut<DaoGlobalInfo<TokenT>>(Token::token_address<TokenT>());
        // emit_event(
        //     &mut gov_info.proposal_create_event,
        //     ProposalCreatedEvent { proposal_id, proposer },
        // );
    }

    
    }